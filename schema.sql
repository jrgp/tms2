-- MariaDB dump 10.19  Distrib 10.5.12-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: jrgporg_tms
-- ------------------------------------------------------
-- Server version	10.5.12-MariaDB-0+deb11u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `affiliates`
--

DROP TABLE IF EXISTS `affiliates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `affiliates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `img` varchar(100) NOT NULL,
  `url` varchar(100) NOT NULL,
  `title` varchar(50) NOT NULL,
  `contact` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `img` (`img`,`url`,`title`,`contact`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `forum_boards`
--

DROP TABLE IF EXISTS `forum_boards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_boards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `forum_posts`
--

DROP TABLE IF EXISTS `forum_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_posts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `topic` int(11) unsigned NOT NULL,
  `poster` int(11) unsigned NOT NULL,
  `date` int(11) unsigned NOT NULL,
  `lastedit` int(11) unsigned NOT NULL,
  `post` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `topic` (`topic`),
  KEY `poster` (`poster`,`lastedit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `forum_topics`
--

DROP TABLE IF EXISTS `forum_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_topics` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `locked` int(1) unsigned NOT NULL DEFAULT 0,
  `sticky` int(1) unsigned NOT NULL DEFAULT 0,
  `board` int(11) unsigned DEFAULT NULL,
  `poster` int(11) unsigned NOT NULL,
  `date` int(11) unsigned NOT NULL,
  `lastedit` int(11) unsigned NOT NULL,
  `lastpost` int(11) unsigned NOT NULL,
  `lastposter` int(11) unsigned NOT NULL DEFAULT 0,
  `post` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `numreplies` int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `poster` (`poster`,`date`,`lastedit`,`lastpost`),
  KEY `title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gametypes`
--

DROP TABLE IF EXISTS `gametypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gametypes` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `nummaps` mediumint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `map_download_log`
--

DROP TABLE IF EXISTS `map_download_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `map_download_log` (
  `when` int(11) unsigned NOT NULL,
  `map` int(11) unsigned NOT NULL,
  `who` int(11) NOT NULL DEFAULT 0,
  `from` text  NOT NULL,
  `agent` text  DEFAULT NULL,
  `ip` varchar(42) DEFAULT NULL,
  PRIMARY KEY (`when`),
  KEY `map` (`map`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `map_downloads`
--

DROP TABLE IF EXISTS `map_downloads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `map_downloads` (
  `mapid` int(11) unsigned NOT NULL DEFAULT 0,
  `file` mediumint(11) unsigned NOT NULL DEFAULT 0,
  `pic` mediumint(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`mapid`),
  KEY `file` (`file`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `map_ratings`
--

DROP TABLE IF EXISTS `map_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `map_ratings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mapid` int(11) unsigned NOT NULL,
  `userid` int(11) unsigned NOT NULL,
  `rating` int(1) unsigned DEFAULT 0,
  `comment` text NOT NULL,
  `date` int(11) unsigned NOT NULL DEFAULT 0,
  `ip` tinytext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mapid` (`mapid`),
  KEY `userid` (`userid`),
  CONSTRAINT `map_ratings_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mapoftheweek`
--

DROP TABLE IF EXISTS `mapoftheweek`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mapoftheweek` (
  `wk` int(11) unsigned NOT NULL,
  `mid` int(11) unsigned NOT NULL,
  `dl` int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`mid`),
  KEY `wk` (`wk`),
  CONSTRAINT `mapoftheweek_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `maps` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maps`
--

DROP TABLE IF EXISTS `maps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `maps` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user` int(11) unsigned NOT NULL,
  `gametype` tinyint(3) unsigned NOT NULL,
  `title` varchar(150) CHARACTER SET utf8 NOT NULL,
  `img` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `sc1` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sc2` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sc3` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `info` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date` int(11) unsigned DEFAULT NULL,
  `lastedit` int(11) unsigned NOT NULL DEFAULT 0,
  `beta` enum('0','1') NOT NULL DEFAULT '0',
  `missing` enum('0','1') NOT NULL DEFAULT '0',
  `no_comments` enum('0','1') NOT NULL DEFAULT '0',
  `rec_players_start` tinyint(2) unsigned NOT NULL DEFAULT 0,
  `rec_players_end` tinyint(2) unsigned NOT NULL DEFAULT 0,
  `download_disabled` int(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `gametype` (`gametype`),
  KEY `user` (`user`),
  KEY `missing` (`missing`),
  CONSTRAINT `maps_ibfk_1` FOREIGN KEY (`user`) REFERENCES `members` (`id`),
  CONSTRAINT `maps_ibfk_2` FOREIGN KEY (`gametype`) REFERENCES `gametypes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `provider` varchar(32) NOT NULL DEFAULT '',
  `provider_id` varchar(50) DEFAULT NULL,
  `regdate` int(11) unsigned NOT NULL,
  `pending` varchar(32) NOT NULL DEFAULT '1',
  `email` varchar(200) NOT NULL DEFAULT '',
  `lastip` varchar(42) DEFAULT NULL,
  `lastaction` int(11) unsigned DEFAULT NULL,
  `timezone_offset` tinyint(3) NOT NULL DEFAULT 0,
  `hide_email` enum('0','1') NOT NULL DEFAULT '0',
  `pm_notif` enum('0','1') NOT NULL DEFAULT '0',
  `mr_notif` enum('0','1') NOT NULL DEFAULT '0',
  `mlc` enum('0','1') NOT NULL DEFAULT '0',
  `avatar_url` varchar(20) DEFAULT NULL,
  `msn` varchar(100) DEFAULT NULL,
  `banned` enum('0','1') NOT NULL DEFAULT '0',
  `nummaps` mediumint(11) unsigned NOT NULL DEFAULT 0,
  `theme` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `nobwfilter` enum('0','1') NOT NULL DEFAULT '0',
  `forumposts` int(11) unsigned NOT NULL DEFAULT 0,
  `forumadmin` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `layout_pref` enum('0','1') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_provider` (`username`, `provider`),
  KEY `nummaps` (`nummaps`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `date` int(11) unsigned NOT NULL,
  `news` text NOT NULL,
  `user` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `online`
--

DROP TABLE IF EXISTS `online`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `online` (
  `uid` int(11) unsigned NOT NULL,
  `time` int(11) unsigned NOT NULL,
  PRIMARY KEY (`uid`),
  CONSTRAINT `online_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pm`
--

DROP TABLE IF EXISTS `pm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pm` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `to` mediumint(11) unsigned NOT NULL,
  `from` mediumint(11) unsigned NOT NULL,
  `date` int(11) unsigned NOT NULL,
  `subject` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `to` (`to`),
  KEY `read` (`read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `poll_options`
--

DROP TABLE IF EXISTS `poll_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_options` (
  `option_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `poll_id` int(11) unsigned NOT NULL,
  `votes` int(11) unsigned NOT NULL DEFAULT 0,
  `option` varchar(200) NOT NULL,
  PRIMARY KEY (`option_id`),
  KEY `poll_id` (`poll_id`),
  CONSTRAINT `poll_options_ibfk_1` FOREIGN KEY (`poll_id`) REFERENCES `poll_questions` (`poll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `poll_questions`
--

DROP TABLE IF EXISTS `poll_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_questions` (
  `poll_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `total_votes` int(11) unsigned NOT NULL DEFAULT 0,
  `locked` int(1) unsigned NOT NULL DEFAULT 0,
  `date` int(11) unsigned NOT NULL,
  `question` varchar(200) NOT NULL,
  PRIMARY KEY (`poll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `poll_votes`
--

DROP TABLE IF EXISTS `poll_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_votes` (
  `vote_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `poll_id` int(11) unsigned NOT NULL,
  `option_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `date` int(11) unsigned NOT NULL,
  PRIMARY KEY (`vote_id`),
  KEY `poll_id` (`poll_id`),
  KEY `option_id` (`option_id`),
  CONSTRAINT `poll_votes_ibfk_1` FOREIGN KEY (`poll_id`) REFERENCES `poll_questions` (`poll_id`),
  CONSTRAINT `poll_votes_ibfk_2` FOREIGN KEY (`option_id`) REFERENCES `poll_options` (`option_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prefabs`
--

DROP TABLE IF EXISTS `prefabs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prefabs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `author` int(10) unsigned NOT NULL,
  `name` varchar(100) NOT NULL,
  `info` text DEFAULT NULL,
  `pfb_ext` varchar(3) NOT NULL,
  `img_ext` varchar(3) NOT NULL,
  `file_hash` varchar(32) NOT NULL,
  `pfb_hash` varchar(32) NOT NULL,
  `downloads` mediumint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `private_maps`
--

DROP TABLE IF EXISTS `private_maps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `private_maps` (
  `MapID` int(10) unsigned NOT NULL,
  `UploadDate` int(10) unsigned NOT NULL,
  `Uploader` int(10) unsigned NOT NULL,
  `Info` text DEFAULT NULL,
  `Viewers` text NOT NULL,
  `FileDowns` int(11) NOT NULL DEFAULT 0,
  `PicDowns` int(11) NOT NULL DEFAULT 0,
  `MapFilePath` text NOT NULL,
  `PicFilePath` text NOT NULL,
  `Sc1Path` text DEFAULT NULL,
  `Sc2Path` text DEFAULT NULL,
  `Sc3Path` text DEFAULT NULL,
  PRIMARY KEY (`MapID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `resources`
--

DROP TABLE IF EXISTS `resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resources` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` char(100) NOT NULL,
  `downloads` int(5) unsigned NOT NULL DEFAULT 0,
  `filename` char(104) NOT NULL,
  `author` int(11) unsigned NOT NULL,
  `type` tinyint(4) unsigned NOT NULL,
  `hash` varchar(32) NOT NULL,
  `info` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `title` (`title`,`author`,`type`,`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `setting` varchar(100) NOT NULL,
  `value` varchar(100) NOT NULL,
  PRIMARY KEY (`setting`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shoutbox`
--

DROP TABLE IF EXISTS `shoutbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shoutbox` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user` int(11) unsigned NOT NULL,
  `date` int(11) unsigned NOT NULL,
  `msg` text NOT NULL,
  `private` enum('0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user` (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sigprefs`
--

DROP TABLE IF EXISTS `sigprefs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sigprefs` (
  `user` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `scheme` int(10) unsigned NOT NULL,
  `font` int(11) NOT NULL,
  `showave` tinyint(1) NOT NULL,
  PRIMARY KEY (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `track_actions`
--

DROP TABLE IF EXISTS `track_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `track_actions` (
  `action` varchar(100) NOT NULL,
  `hits` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tutorial_comments`
--

DROP TABLE IF EXISTS `tutorial_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tutorial_comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user` int(10) unsigned NOT NULL,
  `date` int(11) unsigned NOT NULL,
  `tutorial` int(10) unsigned NOT NULL,
  `comment` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tutorial` (`tutorial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tutorial_ratings`
--

DROP TABLE IF EXISTS `tutorial_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tutorial_ratings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tutorial` int(10) unsigned NOT NULL,
  `user` int(10) unsigned NOT NULL,
  `rating` tinyint(2) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tutorial` (`tutorial`,`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tutorials`
--

DROP TABLE IF EXISTS `tutorials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tutorials` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user` int(10) unsigned NOT NULL,
  `dateuploaded` int(10) unsigned NOT NULL,
  `dateupdated` int(10) unsigned NOT NULL DEFAULT 0,
  `title` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`),
  KEY `user` (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `user_log`
--

DROP TABLE IF EXISTS `user_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_log` (
  `time` int(11) unsigned NOT NULL,
  `day` int(10) unsigned NOT NULL DEFAULT 0,
  `who` int(11) unsigned NOT NULL,
  `action` int(11) unsigned NOT NULL,
  PRIMARY KEY (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

