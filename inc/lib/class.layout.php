<?php

// TMS Rewritten - Early 2010
// By Joseph Robert Gillotti

defined('in_tms') or exit;

// HTML output management

class Layout {

	// Hold themes
	public
		$themes = array(),
		$current_theme = 0,
		$ob = true;

	// Stuff dealing with the nav and files to use
	private
		$nav = array(),
		$css = array('main.css'),
		$js = array('layout.js', 'common.js'),
		$meta = array();


	/*
	 * Start us off by determining the themes and nav
	 */
	function __construct() {

		/*
		 * Construct navigation
		 */
		$this->nav = array(
			array('act' => 'home', 'name' => 'Home'),
			array('act' => 'maps', 'name' => 'Map Search', 'c' => array('maps', 'map_rate', 'user_maps')),
			array('act' => 'members', 'name' => 'Members'),
			array('act' => 'contact', 'name' => 'Contact'),
		);

		/*
		 * Holidays?
		 */
		if(isset($_GET['snow']) || (date('m') == 12 && date('d') > 24 && date('d') < 26))
			$this->js[] = 'snow.js';
	}

	/*
	 * Determine themes. Call this after the user class has been started
	 */
	function determineTheme() {

		global $ui, $sp;

		// Get available themes
		$this->themes = (array) @glob($sp['local_theme'].'theme_*.css');

		// Custom theme via url which overrides saved
		if (isset($_GET['c_theme']) && is_numeric($_GET['c_theme']) && array_key_exists($_GET['c_theme'], $this->themes)) {
			$this->current_theme = $_GET['c_theme'];
		}

		// Get a user's preference if we have the user class loaded
		elseif (is_object($ui))
		{
			// Which one? Default to first if invalid
			$this->current_theme = array_key_exists($ui->userTheme(), $this->themes) ? $ui->userTheme() : 0;
		}

		// Or default to first
		else {
			$this->current_theme = 0;
		}

		// Path to it etc
		$this->css[] = basename($this->themes[$this->current_theme]);


	}


	/*
	 *  Main layout header
	 */
	public function head($title = '') {

		// Need paths
		global $sp, $web_url, $entry_point, $entry_point_sm, $fluid_layout_actions;

		// Need SQL and USER classes
		global $sql, $ui;

		// Buffering to make us faster, smaller?
		if ($this->ob)
			ob_start('ob_gzhandler');

		// Start sending it out
		echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="icon" type="image/x-icon" href="/favicon.ico" />';

	// Send out extra meta tags
	foreach($this->meta as $m)
	echo '
	<meta property="'.htmlspecialchars($m[0]).'" content="'.htmlspecialchars($m[1]).'" />';

	// Send out CSS deps
	foreach ($this->css as $f)
	echo '
	<link href="'.$sp['web_theme'].$f.'?v='.@filemtime($sp['local_theme'].$f).'" rel="stylesheet" type="text/css" />';

	// And JS
	foreach ($this->js as $f)
	echo '
	<script type="text/javascript" src="'.$sp['web_theme'].$f.'?v='.@filemtime($sp['local_theme'].$f).'"></script>';

	echo '
	<title>The Soldat2 Mapping Showcase ',$title ? ' &raquo; '.htmlspecialchars($title) : '','</title>
	<style type="text/css">
		#wrapper {
			width: ',@$_SESSION['site_width'] == 'fluid' || in_array(SITE_ACTION, $fluid_layout_actions) ? '95%' : '770px',';
		}
	</style>
	<script type="text/javascript">
		user_sessid = \''.session_id().'\';
		width = \'',@$_SESSION['site_width'] == 'fluid' || in_array(SITE_ACTION, $fluid_layout_actions) ? 'fluid' : 'fixed','\';
	</script>
</head>
<body id="tms">
	<div id="wrapper">
		<div id="head">
			<div id="logo"><a href="'.$web_url.'" title="Soldat2 Mapping Showcase"></a></div>
			<ul id="nav">';

		// Send out nav
		foreach ($this->nav as $n)
			echo '
				<li><a',(isset($n['c']) && is_array($n['c']) && in_array(SITE_ACTION, $n['c'])) || SITE_ACTION == $n['act'] ? ' class="c"' : '',' href="'.$entry_point.'?action='.$n['act'].'" title="'.$n['name'].'">'.$n['name'].'</a></li>';

		echo '
			</ul>
			<div id="btns">
				<a title="Use this for linking" href="'.$entry_point_sm.'"><img src="/images/tms.gif" alt="TMS" /></a>
				<a href="http://u13.net" id="u13" title="U13 Powered"><img src="/images/u13-at.gif" alt="U13 Powered" /></a>
			</div>
		</div>
		<div id="user_panel">
			<div id="user_greeting">
				Hello,
				',$ui->loggedIn() ? '<a href="'.$entry_point.'?action=view_profile&amp;u='.$ui->userID().'">'.stringprep($ui->userName()).'</a>' : 'Guest','
				</div>
			<div id="layout_collapse">';

			// If we're forced fluid, show arrows grayed out
			if (in_array(SITE_ACTION, $fluid_layout_actions)) {
				echo '&laquo; &middot; &raquo;';
			}
			// Otherwise let you choose
			else {
				echo '
				<a href="'.$entry_point.'?action=change_layout&amp;sa=width&amp;w=fixed" onclick="set_width(\'fixed\'); return false;" title="Fixed width">&laquo;</a>
				&middot;
				<a href="'.$entry_point.'?action=change_layout&amp;sa=width&amp;w=fluid" onclick="set_width(\'fluid\'); return false;" title="Fluid width">&raquo;</a>';
			}

			echo '
			</div>';

			// User panel
			if ($ui->loggedIn()) {
			echo '
			<div style="overflow: hidden;">
				<div id="ave"><img style="width: 60px; height: 60px;" src="/a/'.$ui->userID().'" alt="'.stringprep($ui->userName()).'" /></div>
				<ul id="user_actions">
					<li><a href="'.$entry_point.'?action=map_upload">Map Upload</a> | <a href="'.$entry_point.'?action=my_maps">My Maps</a></li>
					<li><a href="'.$entry_point.'?action=profile">Settings</a></li>
					<li><a href="'.$entry_point.'?action=logout">Logout</a></li>
				</ul>
			</div>
			';

			// Show some fun stuff
			$get_my_maps = $sql->query("
			select
				id,
				title,
				img
			from
				maps
			where
				user = '".$ui->userID()."' and
				missing = '0'
			order by rand()
			limit 3
			");

			// If we've got them, show them
			if ($sql->num($get_my_maps) > 0) {

				echo '<a id="head_my_maps" title="My Maps" href="'.$entry_point_sm.'?user='.$ui->userID().'">';

				// Make each 5px lower and more to the right.
				for($i = 0; list($mid, $mtitle, $mpath) = $sql->fetch_row($get_my_maps); $i += 5) {

					// Show it
					echo '
				<img class="border" alt="'.stringprep($mtitle).'" style="top: '.$i.'px; left: '.$i.'px;" width="45" height="45" src="/t/'.$mid.':45x45" />';
				}
			}

			echo '
			</a>
			';

			// Free ram that used
			$sql->free($get_my_maps);

		}
			else
			echo '
      <div style="overflow: hidden; padding: 10px;">
        <a href="'.$entry_point.'?action=auth_discord">Login with Discord!</a>
      </div>
			';

		echo '
		</div>
		<div id="content_out">
			<div id="content">
				<h1><span>'.htmlspecialchars($title).'</span></h1>
				<div id="content_inner">
		';

	}

	/*
	 *  Main layout footer
	 */
	public function foot() {

		// Gain access to hits and stuff
		global $ui, $sql, $entry_point, $time_start, $sp;

echo '

				</div>
			</div>
		</div>
		<div id="side">
			<div class="widge poll" id="poll">
				<h2><span>Poll</span><span class="fake_link border" onclick="toggle_show(\'poll_content\', this);">',$this->checkHidden('poll_content') ? '-' : '+','</span></h2>
				<div id="poll_content"',$this->checkHidden('poll_content') ? '' : ' style="display: none;"','>';

					/*
					 *
					 * Poll
					 *
					 */

					// Get latest poll
					$get_poll = $sql->query("
						select
							pq.poll_id,
							pq.total_votes,
							pq.locked,
							pq.question
						from
							poll_questions as pq
						order by pq.poll_id desc
						limit 1
					");

					$poll_info = $sql->fetch_assoc($get_poll);
					$sql->free($get_poll);

          if ($poll_info != false) {

					// Get options
					$poll_options = array();

					$get_options = $sql->query("
						select
							po.option_id,
							po.votes,
							po.option
						from
							poll_options as po
						where
							po.poll_id = '{$poll_info['poll_id']}'
						order by po.option desc
					");

					// Stuff it
					while ($info = $sql->fetch_row($get_options))
						$poll_options[$info[0]] = array($info[1], stringprep($info[2]));

					$sql->free($get_options);

					// Am I logged in? Have I voted?
					if ($ui->loggedIn()) {

						// Get my vote
						$get_me = $sql->query("select pv.option_id from poll_votes as pv where pv.poll_id = '{$poll_info['poll_id']}' and pv.user_id = '".$ui->userID()."' limit 1");

						if ($sql->num($get_me) == 1) {
							list($my_vote_id) = $sql->fetch_row($get_me);
							$voted = true;
						}
						else {
							$voted = false;
						}

						$sql->free($get_me);
					}

					// Send out question
					echo '
					<p class="poll_question">'.stringprep($poll_info['question']).'</p>';

					// Start form if needed
					if ($ui->loggedIn() && $voted == false)
						echo '
					<form action="'.$entry_point.'?action=poll_vote" method="post">
						<div>
							<input type="hidden" id="pid" name="pid" value="'.$poll_info['poll_id'].'" />
						</div>';

					// Start options list
					echo '
					<ul class="poll_options">';


					// If I am not logged in, just show options
					if (!$ui->loggedIn()) {
						foreach ($poll_options as $option)
						echo '
						<li class="border">'.$option[1].'</li>';
					}

					// if I am logged in and haven't voted
					elseif($ui->loggedIn() && $voted == false) {
						foreach ($poll_options as $option_id => $option)
						echo '
						<li class="border"><input onchange="this.form.submit();" type="radio" id="poll_op_'.$option_id.'" name="oid" value="'.$option_id.'" /><label for="poll_op_'.$option_id.'" class="poll_option_op">'.$option[1].'</label></li>';
					}

					// if I am logged in and have voted. (and can hence see results)
					elseif($ui->loggedIn() && $voted == true) {
						foreach ($poll_options as $option_id => $option) {
							$this_percent = $option[0] == 0 ? 0 : round(($option[0] / $poll_info['total_votes']) * 100);
							echo '
							<li class="border',$option_id == $my_vote_id ? ' my_vote' : '','">
								<div class="alt poll_option_bar" style="width: '.$this_percent.'%;">
									<div class="poll_option">
										<span class="poll_option_op">'.$option[1].'</span>  <span class="poll_option_sub">'.$this_percent.'% - '.$option[0].' votes</span>
									</div>
								</div>
							</li>';
						}
					}

					// Finish option list
					echo '
					</ul>';

					// Finish form if there was one
					if ($ui->loggedIn() && $voted == false)
						echo '</form>';

					// Link to prior polls
					echo '
					<p id="poll_view_all">
						Votes: '.$poll_info['total_votes'].'<br />
						<a href="'.$entry_point.'?action=poll_history">View old polls</a>
					</p>';

        } else {
           echo '<p id="poll_view_all">No polls yet</p>';
        }

				echo '
				</div>
			</div>
			<div class="widge" id="shoutbox">
				<h2><span>Shoutbox</span><span class="fake_link border" onclick="toggle_show(\'shoutbox_content\', this);">',$this->checkHidden('shoutbox_content') ? '-' : '+','</span></h2>
				<div id="shoutbox_content"',$this->checkHidden('shoutbox_content') ? '' : ' style="display: none;"','>';

					/*
					 *
					 * Shoutbox
					 *
					 */

					// Get shouts
					$get_shouts = $sql->query("select sb.date, sb.user, sb.msg, u.username from shoutbox as sb join members as u on u.id = sb.user order by sb.id desc limit 10");

					// Hold them here
					$shouts = array();

					// Stuff it
					while ($shout = $sql->fetch_row($get_shouts)) {
						$shouts[] = array(
							'date' => $shout[0],
							'name' => stringprep($shout[3], true),
							'uid' => $shout[1],
							'msg' => str_replace("\n", '', stringprep($shout[2], true, true, 2))
						);
					}

					// Free
					$sql->free($get_shouts);

					echo '<p style="padding: 0px; margin: 5px; text-align: center; font-size: 10px;">
						Last:
						'.($ui->myDate('m/d/y') == $ui->myDate('m/d/y', $shouts[0]['date']) ? 'Today' : $ui->myDate('m/d/Y', $shouts[0]['date'])).$ui->myDate(' @ h:i A', $shouts[0]['date']).'
					</p>';

					// Give them
					$alt = false;
					foreach ($shouts as $shout) {
						echo '
						<p title="Posted: '.$ui->myDate(DATE_FORMAT, $shout['date']).'" class="p',$alt ? ' alt' : '','"><span>'.userLink($shout['uid'], $shout['name']).' says:</span> '.$shout['msg'].'</p>';
						$alt = !$alt;
					}

					echo '
					<h2 class="sect"><span>Shout</span></h2>';

					// Reply?
					if ($ui->loggedIn())
					echo '
<script>
document.write([
\'<fo\' +
\'rm act\' + \'ion="'.$entry_point.'?acti\' + \'on=shout" method="post" onclick="return shout_submit(this);">\',
\'	<div id="sb_form_contents">\',
\'		<label for="sb_main_msg">Message: </label>\',
\'		<textarea name="sb_main_msg" id="sb_main_msg" cols="4" rows="4"></textarea>\',
\'		<input type="hidden" name="'.$ui->verifKey().'" value="'.$ui->verifVal().'" />\',
\'		<input type="hidden" id="sb_do_shout" name="sb_do_shout" value="yes" />\',
\'		<div><input type="submit" value="Shout!" /></div>\',
\'	</div>\',
\'</form>\',
].join(""))
</script>
';

					else
						echo '<p>Login to shout</p>';

					// Get number of shouts
					list($total_shouts) = $sql->fetch_row($sql->query("select count(*) from shoutbox"));
					$sql->freelast();

			echo '
					<p><a href="'.$entry_point.'?action=all_shouts">View all '.number_format($total_shouts).' shouts</a></p>
				</div>
			</div>';


			/*
			 * Latest downloaded maps
			 */
			echo '
			<div class="widge" id="last_downloaded_maps">
				<h2><span>Maps just downloaded</span><span class="fake_link border" onclick="toggle_show(\'last_downloaded_maps_content\', this);">',$this->checkHidden('last_downloaded_maps_content') ? '-' : '+','</span></h2>
				<div id="last_downloaded_maps_content"',$this->checkHidden('last_downloaded_maps_content') ? '' : ' style="display: none;"','>
					<ul>
					';

					// Get them
					$get_latest_downloaded_maps = $sql->query("
						select
							m.title,
							l.map,
							d.file,
							l.when
						from
							map_download_log as l
							join maps as m on m.id = l.map
							join map_downloads as d on d.mapid = l.map
						where
							m.missing = '0'
						order by
							l.when
						desc
						limit 14
					");

					// Show them
					for ($alt = false; $info = $sql->fetch_row($get_latest_downloaded_maps); $alt = !$alt)
						echo '<li ',$alt ? ' class="alt"' : '',' title="On '.$ui->myDate('m/d/Y @ h:i A', $info[3]).'"><a href="'.$entry_point.'?map='.$info[1].'">'.stringprep($info[0]).'</a> <span class="sm_note">('.number_format($info[2]).' total)</span></li>';

					// Free ram
					$sql->free($get_latest_downloaded_maps);

					// Get total downloads
					list($total_downloads, $total_downloads_today, $total_downloads_week) = $sql->fetch_row($sql->query("
						select
						(select sum(file) from map_downloads),
						(select count(*) from map_download_log where date(from_unixtime(`when`)) = curdate()),
						(select count(*) from mapoftheweek)
					"));
					$sql->freelast();

					echo '
					</ul>
					<p class="border">
						Total downloads: '.number_format($total_downloads).'<br />
						Downloads this week: '.number_format($total_downloads_week).'<br />
						Downloads Today: '.number_format($total_downloads_today).'</p>
				</div>
			</div>';


			/*
			 * Theme chooser
			 */

			echo '
			<div class="widge">
				<h2><span>Site Color Scheme</span><span class="fake_link border" onclick="toggle_show(\'theme_changer_content\', this);">',$this->checkHidden('theme_changer_content') ? '-' : '+','</span></h2>
				<div id="theme_changer_content"',$this->checkHidden('theme_changer_content') ? '' : ' style="display: none;"','>
					<form id="theme_changer" action="'.$entry_point.'?action=change_layout&amp;sa=theme" method="post">
						<div><select id="theme" name="theme" onchange="this.form.submit();">';

						// Show available themes
						foreach($this->themes as $k => $v)
						{
							// Get title from filename
							if (preg_match('/^theme_([^.]+)\.css$/i', basename($v), $m) == 0)
								continue;

							// Remove underscores and capitalize each word
							$name = ucwords(str_replace('_', ' ', $m[1]));

							// Show option
							echo '
							<option',$this->current_theme == $k ? ' selected="selected"' : '',' value="'.$k.'">'.$name.'</option>';
						}

						echo '
						</select></div>
					</form>
				</div>
			</div>';

			/*
			 * Finish layout
			 */

			// Online users
			$fetch_online = $sql->query("
				select
					o.uid,
					u.username
				from
					online as o
					join members as u on u.id = o.uid
				order by
					u.username asc
			");

			// See if we have any
			if ($sql->num($fetch_online) > 0) {
				// We do, make array for them
				$online_users = array();

				// Fetch them
				while (list($o_uid, $o_un) = $sql->fetch_row())
					$online_users[] = '<a href="'.$entry_point.'?action=view_profile&amp;u='.$o_uid.'">'.stringprep($o_un).'</a>';
			} else {
				// Nothing
				$online_users = false;
			}

			// Free ram that used
			$sql->free($fetch_online);

			// Get number of maps
			$get_num_maps = $sql->query("select count(*) from `maps` where `missing` = '0'");
			list($num_maps) = $sql->fetch_row();
			$sql->free($get_num_maps);

			echo '
		</div>
	</div>
	<div id="foot">
		Online users: ',is_array($online_users) ? implode(', ', $online_users) : '<em>none</em>','<br />
		'.$num_maps.' maps uploaded since sometime in 2022.<br />
		&copy; 2007 &mdash; '.date('Y').' JRG Productions. All Rights Reserved. <a href="'.$entry_point.'?action=credits">Credits</a> | <a href="https://github.com/jrgp/tms2">Git</a>
	</div>
</body>
</html>
';

	// Send out hopefully compressed html tinily
	if ($this->ob)
		ob_end_flush();

	}

	/*
	 * Error Messages..
	 */

	// Include main layout with error message
	public function errorMsg($msg, $title = '') {
		$this->head($title ? $title : 'Error');
		echo '<p class="error">'.$msg.'</p>';
		$this->foot();
		exit;
	}

	// Use minimal layout for error message
	public function errorMsgMinimal($msg, $title = '') {
		$this->mHead($title ? $title : 'Error');
		echo $msg;
		$this->mFoot();
		exit;
	}

	/*
	 * Notifs
	 */
	public function notifMsg($msg, $title = '') {
		$this->head($title ? $title : 'Notification');
		echo '<p class="notif">'.$msg.'</p>';
		$this->foot();
		exit;
	}

	/*
	 * Add a required css or javascript file
	 */
	public function add_dep($type, $file) {
		if ($type == 'css')
			$this->css[] = $file;
		elseif ($type == 'js')
			$this->js[] = $file;
		else
			return false;
		return true;
	}

	/*
	 * Add meta tags. Eg for open graph
	 */
	public function add_meta($key, $value) {
		$this->meta[] = [$key, $value];
	}

	/*
	 * See if a sidebar item is set to be hidden
	 */
	public function checkHidden($area) {
		return !isset($_COOKIE['pref_'.$area]) || $_COOKIE['pref_'.$area] == 1;
	}

	/*
	 * Prompt
	 */
	public function prompt($question = 'Are you sure?', $title = 'Confirmation Prompt') {
		global $entry_point, $ui;

		// Security values that need to be unique and most unguessable
		$security_field_name = md5(date('mdy').md5(session_id()));
		$security_field_value = session_id();

		// Were we allowed to proceed?
		if (isset($_POST[$security_field_name]) && $_POST[$security_field_name] == $security_field_value && $_POST['do_proceed'] == 'yes')
		{
			// leave this function and allow the rest of code under function call to process
			return true;
		}

		// No, show form
		$this->head($title);
		echo '
		<script type="text/javascript">
		/*<![CDATA[*/
		function decision_go()
		{
			document.getElementById(\'prompt_go\').disabled = true;
			document.getElementById(\'prompt_nvm\').disabled = true;
			return true;
		}
		/*]]>*/
		</script>
		<form action="'.$entry_point.'?'.htmlentities($_SERVER['QUERY_STRING']).'" method="post" onsubmit="return decision_go();">
		<div>
		<input type="hidden" id="'.$security_field_name.'" name="'.$security_field_name.'" value="'.$security_field_value.'" />
		<input type="hidden" id="do_proceed" name="do_proceed" value="yes" />
		';

		// deal with prior values
		foreach (array_unique($_POST) as $k => $v) {
			$k = htmlentities(trim($k));
			$v = htmlentities(trim($v));
			echo '<input type="hidden" id="'.$k.'" name="'.$k.'" value="'.$v.'" />';
		}

		echo '
		</div>
		<div class="question">
		<p>'.$question.'</p>
		<input id="prompt_go" type="submit" value="Yes, continue" />
		<input id="prompt_nvm" type="button" onclick="history.go(-1);" value="Cancel" />
		</div>
		</form>
		';
		$this->foot();

		// Entire point of the function is to stop
		exit;

	}

}
