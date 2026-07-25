-- ERP v1.28 ServerCore Login/Register Tracks + Login Timeout

INSERT INTO `servercore` (`keyname`, `value`) VALUES
('LoginTrack', ''),
('RegisterTrack', '')
ON DUPLICATE KEY UPDATE `value`=`value`;

-- Put direct public MP3/stream URLs in value, for example:
-- UPDATE `servercore` SET `value`='https://yourdomain.com/login.mp3' WHERE `keyname`='LoginTrack';
-- UPDATE `servercore` SET `value`='https://yourdomain.com/register.mp3' WHERE `keyname`='RegisterTrack';
