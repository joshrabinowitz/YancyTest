CREATE TABLE `action_queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `symbol` varchar(150) NOT NULL,
  `action` varchar(32) NOT NULL,
  `state` varchar(16) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `symbol__action__uniqueindex` (`symbol`,`action`)
) ENGINE=InnoDB AUTO_INCREMENT=47644759 DEFAULT CHARSET=utf8;

CREATE TABLE `admin_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_date` date NOT NULL,
  `type` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `value` double NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_date__type__unique_index` (`data_date`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=47070404 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `creation_date` datetime NOT NULL,
  `publish_date` datetime NOT NULL,
  `update_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `title` text NOT NULL,
  `category` varchar(32) NOT NULL DEFAULT 'news',
  `html_title` text NOT NULL,
  `subtitle` text NOT NULL,
  `content` text NOT NULL,
  `is_public` int(11) NOT NULL DEFAULT '0',
  `image_file_id` int(11) NOT NULL DEFAULT '1',
  `url` varchar(255) NOT NULL DEFAULT 'filename',
  PRIMARY KEY (`id`),
  KEY `articles__user_id__fk` (`user_id`),
  KEY `articles__image_file_id__fk` (`image_file_id`),
  CONSTRAINT `articles__image_file_id__fk` FOREIGN KEY (`image_file_id`) REFERENCES `files` (`id`),
  CONSTRAINT `blog_posts__user_id__fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `articles_archive` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `creation_date` datetime NOT NULL,
  `publish_date` datetime NOT NULL,
  `update_date` datetime NOT NULL,
  `title` text NOT NULL,
  `category` varchar(32) NOT NULL DEFAULT 'news',
  `html_title` text NOT NULL,
  `subtitle` text NOT NULL,
  `content` text NOT NULL,
  `is_public` int(11) NOT NULL DEFAULT '0',
  `image_file_id` int(11) NOT NULL DEFAULT '1',
  `url` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `articles__user_id__fk` (`user_id`),
  KEY `article_id__index` (`article_id`),
  KEY `articles_archive__image_file_id__fk` (`image_file_id`),
  CONSTRAINT `articles_archive__image_file_id__fk` FOREIGN KEY (`image_file_id`) REFERENCES `files` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `datacache` (
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expire_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `name` varchar(255) NOT NULL,
  `value` blob NOT NULL,
  UNIQUE KEY `name__index` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

CREATE TABLE `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filesize` int(11) NOT NULL,
  `md5` char(22) COLLATE utf8mb4_unicode_ci NOT NULL,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `filename_idx` (`filename`),
  KEY `files__user_id__fk` (`user_id`),
  CONSTRAINT `files__user_id__fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `files_archive` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `filename` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filesize` int(11) NOT NULL,
  `md5` char(22) COLLATE utf8mb4_unicode_ci NOT NULL,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `filename_idx` (`filename`),
  KEY `files_archive__user_id__fk` (`user_id`),
  CONSTRAINT `files_archive__user_id__fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_role` (`user_id`,`role_id`),
  KEY `user_roles__role_id__fk` (`role_id`),
  CONSTRAINT `user_roles__role_id__fk` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `user_roles__user_id__fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email__unique_index` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10010 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

