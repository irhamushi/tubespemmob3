-- Database: traffic_system
-- Run in MySQL (via phpMyAdmin / mysql client)

CREATE DATABASE IF NOT EXISTS `traffic_system` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `traffic_system`;

DROP TABLE IF EXISTS `traffic_light`;

CREATE TABLE `traffic_light` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `junction_id` INT NOT NULL DEFAULT 1,
  `direction` VARCHAR(50) DEFAULT NULL,
  `lat` DOUBLE NOT NULL,
  `lng` DOUBLE NOT NULL,
  `status` ENUM('RED','YELLOW','GREEN') NOT NULL DEFAULT 'RED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample data: two junctions (3 directions each)
INSERT INTO `traffic_light` (`junction_id`,`direction`,`lat`,`lng`,`status`) VALUES
(1,'NORTH',-6.9900,110.4229,'GREEN'),
(1,'EAST', -6.9902,110.4235,'RED'),
(1,'SOUTH',-6.9910,110.4220,'RED'),
(2,'NORTH',-6.9925,110.4240,'GREEN'),
(2,'EAST', -6.9928,110.4246,'RED'),
(2,'SOUTH',-6.9932,110.4236,'RED');
