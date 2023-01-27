<?php

defined('in_tms') or exit;

$ui->loggedIn() and
	$layout->errorMsg('Already authenticated');


$provider = new \Wohali\OAuth2\Client\Provider\Discord([
  'clientId' => DISCORD_CLIENT_ID,
  'clientSecret' => DISCORD_SECRET_KEY,
  'redirectUri' => $entry_point,
]);

if (!isset($_GET['code'])) {

    $options = [
      'scope' => ['identify'],
      'state' => 'DISCORDAUTH_'.base64_encode(random_bytes(20)),
    ];

    // Step 1. Get authorization code
    $authUrl = $provider->getAuthorizationUrl($options);
    $_SESSION['discord_oauth2_state'] = $provider->getState();
    header('Location: ' . $authUrl);

// Check given state against previously stored one to mitigate CSRF attack
} elseif (empty($_GET['state']) || ($_GET['state'] !== $_SESSION['discord_oauth2_state'])) {

    unset($_SESSION['discord_oauth2_state']);
    exit('Invalid state');

} else {

    // Step 2. Get an access token using the provided authorization code
    $token = $provider->getAccessToken('authorization_code', [
        'code' => $_GET['code']
    ]);

    // Step 3. (Optional) Look up the user's profile with the provided token
    try {

        $user = $provider->getResourceOwner($token);

        $username = sprintf('%s#%s', $user->getUsername(), $user->getDiscriminator());
        $discord_id = (string)$user->getId();

        // At this point, we are auth'd. Create an account if one does not exist, otherwise
        // log the user in

        $query = $sql->query("select `id` from `members` where `provider` = 'discord' and `provider_id` = '{$sql->prot($discord_id)}' limit 1");
        if ($sql->num($query) == 1) {
            // We have an account. Initialize login session and go home
            $row = $sql->fetch_assoc($query);
            $uid = $row['id'];

            // Update display name in DB for this ID
            $sql->query("update members set `username` = '{$sql->prot($username)}' where id = '{$sql->prot($uid)}' limit 1");

        } else {

            $query = $sql->query("select `id` from `members` where `provider` = 'discord' and `username` = '{$sql->prot($username)}' limit 1");

            if ($sql->num($query) == 1) {
              // We have an account. Initialize login session and go home
              $row = $sql->fetch_assoc($query);
              $uid = $row['id'];

              // Update provider ID in DB for this ID
              $sql->query("update members set `provider_id` = '{$sql->prot($discord_id)}' where id = '{$sql->prot($uid)}' limit 1");

            } else {
              // No account. Create one.
              $sql->query("
                insert into `members` set
                  `username` = '{$sql->prot($username)}',
                  `email` = '',
                  `pending` = '0',
                  `provider` = 'discord',
                  `provider_id` = '{$sql->prot($discord_id)}',
                  `regdate` = UNIX_TIMESTAMP()
                ");
              $uid = $sql->lastid();
            }
        }

        // Create login session with our new UID
          $ui->createAuthSession($uid);
          redirect('/');

    } catch (Exception $e) {

        // Failed to get user details
        exit('Failed to use token to get discord details');

    }
}
