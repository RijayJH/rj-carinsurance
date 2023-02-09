CREATE TABLE IF NOT EXISTS `rj-carinsurance` (
  `vehicle` varchar(100) NOT NULL,
  `date` text DEFAULT NULL,
  PRIMARY KEY (`vehicle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;