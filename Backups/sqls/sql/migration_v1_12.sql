-- ERP v1.12 migration: login screen news
INSERT INTO `servercore` (`keyname`,`value`) VALUES
('News','Welcome to Express Roleplay - Gaming!')
ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);
