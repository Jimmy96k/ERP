-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 29, 2026 at 02:09 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `expressrp`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `username` varchar(24) NOT NULL,
  `password` varchar(129) NOT NULL,
  `tutorial` int(11) NOT NULL DEFAULT 0,
  `admin` int(11) NOT NULL DEFAULT 0,
  `vip` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `playing_hours` int(11) NOT NULL DEFAULT 0,
  `age` int(11) NOT NULL DEFAULT 18,
  `dob` varchar(16) NOT NULL DEFAULT '',
  `country` varchar(32) NOT NULL DEFAULT 'Unknown',
  `gender` int(11) NOT NULL DEFAULT 1,
  `accent` int(11) NOT NULL DEFAULT 0,
  `skin` int(11) NOT NULL DEFAULT 26,
  `cash` int(11) NOT NULL DEFAULT 1000,
  `bank` int(11) NOT NULL DEFAULT 9000,
  `phone` int(11) NOT NULL DEFAULT 0,
  `phonebook` int(11) NOT NULL DEFAULT 0,
  `phone_off` int(11) NOT NULL DEFAULT 0,
  `has_radio` int(11) NOT NULL DEFAULT 0,
  `radio_freq` int(11) NOT NULL DEFAULT 0,
  `vehicle_lock` int(11) NOT NULL DEFAULT 0,
  `hosp_insurance` int(11) NOT NULL DEFAULT 9999,
  `married_to` varchar(24) NOT NULL DEFAULT '',
  `crimes` int(11) NOT NULL DEFAULT 0,
  `arrests` int(11) NOT NULL DEFAULT 0,
  `wanted_level` int(11) NOT NULL DEFAULT 0,
  `materials` int(11) NOT NULL DEFAULT 0,
  `pot` int(11) NOT NULL DEFAULT 0,
  `crack` int(11) NOT NULL DEFAULT 0,
  `rope` int(11) NOT NULL DEFAULT 0,
  `packages` int(11) NOT NULL DEFAULT 0,
  `seeds` int(11) NOT NULL DEFAULT 0,
  `sprunk` int(11) NOT NULL DEFAULT 0,
  `cigar` int(11) NOT NULL DEFAULT 0,
  `spraycans` int(11) NOT NULL DEFAULT 0,
  `health` float NOT NULL DEFAULT 100,
  `armor` float NOT NULL DEFAULT 0,
  `respect_points` int(11) NOT NULL DEFAULT 0,
  `warnings` int(11) NOT NULL DEFAULT 0,
  `hospital_time` int(11) NOT NULL DEFAULT 30,
  `tog_free_hospital` int(11) NOT NULL DEFAULT 0,
  `family_id` int(11) NOT NULL DEFAULT 0,
  `faction_id` int(11) NOT NULL DEFAULT 0,
  `family_rank` int(11) NOT NULL DEFAULT 0,
  `family_crew` int(11) NOT NULL DEFAULT 0,
  `business_id` int(11) NOT NULL DEFAULT 0,
  `spawn_x` float NOT NULL DEFAULT 1642.18,
  `spawn_y` float NOT NULL DEFAULT -2334.9,
  `spawn_z` float NOT NULL DEFAULT 13.54,
  `spawn_a` float NOT NULL DEFAULT 0,
  `spawn_int` int(11) NOT NULL DEFAULT 0,
  `spawn_vw` int(11) NOT NULL DEFAULT 0,
  `job0` int(11) NOT NULL DEFAULT 0,
  `job1` int(11) NOT NULL DEFAULT 0,
  `job2` int(11) NOT NULL DEFAULT 0,
  `job3` int(11) NOT NULL DEFAULT 0,
  `job4` int(11) NOT NULL DEFAULT 0,
  `job5` int(11) NOT NULL DEFAULT 0,
  `job6` int(11) NOT NULL DEFAULT 0,
  `job7` int(11) NOT NULL DEFAULT 0,
  `job8` int(11) NOT NULL DEFAULT 0,
  `job9` int(11) NOT NULL DEFAULT 0,
  `weapon0` int(11) NOT NULL DEFAULT 0,
  `weapon1` int(11) NOT NULL DEFAULT 0,
  `weapon2` int(11) NOT NULL DEFAULT 0,
  `weapon3` int(11) NOT NULL DEFAULT 0,
  `weapon4` int(11) NOT NULL DEFAULT 0,
  `weapon5` int(11) NOT NULL DEFAULT 0,
  `weapon6` int(11) NOT NULL DEFAULT 0,
  `weapon7` int(11) NOT NULL DEFAULT 0,
  `weapon8` int(11) NOT NULL DEFAULT 0,
  `weapon9` int(11) NOT NULL DEFAULT 0,
  `weapon10` int(11) NOT NULL DEFAULT 0,
  `weapon11` int(11) NOT NULL DEFAULT 0,
  `weapon12` int(11) NOT NULL DEFAULT 0,
  `fav_radio` int(11) NOT NULL DEFAULT 0,
  `faction_rank` int(11) NOT NULL DEFAULT 0,
  `faction_division` int(11) NOT NULL DEFAULT 0,
  `max_vehicles` int(11) NOT NULL DEFAULT 0,
  `max_houses` int(11) NOT NULL DEFAULT 0,
  `max_businesses` int(11) NOT NULL DEFAULT 0,
  `max_toys` int(11) NOT NULL DEFAULT 0,
  `has_mp3` tinyint(4) NOT NULL DEFAULT 0,
  `hotwire_level` int(11) NOT NULL DEFAULT 1,
  `hotwire_success` int(11) NOT NULL DEFAULT 0,
  `hotwire_fail` int(11) NOT NULL DEFAULT 0,
  `hotwire_kits` int(11) NOT NULL DEFAULT 0,
  `injured` tinyint(4) NOT NULL DEFAULT 0,
  `hospitalized` tinyint(4) NOT NULL DEFAULT 0,
  `injured_x` float NOT NULL DEFAULT 0,
  `injured_y` float NOT NULL DEFAULT 0,
  `injured_z` float NOT NULL DEFAULT 0,
  `injured_a` float NOT NULL DEFAULT 0,
  `injured_int` int(11) NOT NULL DEFAULT 0,
  `injured_vw` int(11) NOT NULL DEFAULT 0,
  `hospital_id` int(11) NOT NULL DEFAULT -1,
  `hospital_bed` int(11) NOT NULL DEFAULT -1,
  `jobskill_1` int(11) NOT NULL DEFAULT 0,
  `jobskill_2` int(11) NOT NULL DEFAULT 0,
  `jobskill_3` int(11) NOT NULL DEFAULT 0,
  `jobskill_4` int(11) NOT NULL DEFAULT 0,
  `jobskill_5` int(11) NOT NULL DEFAULT 0,
  `jobskill_6` int(11) NOT NULL DEFAULT 0,
  `jobskill_7` int(11) NOT NULL DEFAULT 0,
  `jobskill_8` int(11) NOT NULL DEFAULT 0,
  `jobskill_9` int(11) NOT NULL DEFAULT 0,
  `jobskill_10` int(11) NOT NULL DEFAULT 0,
  `jobskill_11` int(11) NOT NULL DEFAULT 0,
  `repair_kits` int(11) NOT NULL DEFAULT 0,
  `screwdrivers` int(11) NOT NULL DEFAULT 0,
  `has_jerry_can` tinyint(4) NOT NULL DEFAULT 0,
  `jerry_can_fuel` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `username`, `password`, `tutorial`, `admin`, `vip`, `level`, `playing_hours`, `age`, `dob`, `country`, `gender`, `accent`, `skin`, `cash`, `bank`, `phone`, `phonebook`, `phone_off`, `has_radio`, `radio_freq`, `vehicle_lock`, `hosp_insurance`, `married_to`, `crimes`, `arrests`, `wanted_level`, `materials`, `pot`, `crack`, `rope`, `packages`, `seeds`, `sprunk`, `cigar`, `spraycans`, `health`, `armor`, `respect_points`, `warnings`, `hospital_time`, `tog_free_hospital`, `family_id`, `faction_id`, `family_rank`, `family_crew`, `business_id`, `spawn_x`, `spawn_y`, `spawn_z`, `spawn_a`, `spawn_int`, `spawn_vw`, `job0`, `job1`, `job2`, `job3`, `job4`, `job5`, `job6`, `job7`, `job8`, `job9`, `weapon0`, `weapon1`, `weapon2`, `weapon3`, `weapon4`, `weapon5`, `weapon6`, `weapon7`, `weapon8`, `weapon9`, `weapon10`, `weapon11`, `weapon12`, `fav_radio`, `faction_rank`, `faction_division`, `max_vehicles`, `max_houses`, `max_businesses`, `max_toys`, `has_mp3`, `hotwire_level`, `hotwire_success`, `hotwire_fail`, `hotwire_kits`, `injured`, `hospitalized`, `injured_x`, `injured_y`, `injured_z`, `injured_a`, `injured_int`, `injured_vw`, `hospital_id`, `hospital_bed`, `jobskill_1`, `jobskill_2`, `jobskill_3`, `jobskill_4`, `jobskill_5`, `jobskill_6`, `jobskill_7`, `jobskill_8`, `jobskill_9`, `jobskill_10`, `jobskill_11`, `repair_kits`, `screwdrivers`, `has_jerry_can`, `jerry_can_fuel`) VALUES
(1, 'Jimmy_Richardson', '7D73388F9B889B1E59642AEE80007658A8B3041BC6B5F52CFC5E88C84B04DFF67A74E05EB31280FF609177BB27C6093DF4D41EBFDF5BE8112220F85AE84D0CE4', 1, 99999, 5, 1, 0, 18, '01/01/2000', 'Egypt', 1, 5, 300, 220950, 1000, 1000, 1, 0, 1, 100, 0, 1, '', 0, 0, 3, 4250, 0, 0, 8, 0, 0, 0, 0, 0, 95, 100, 0, 0, 0, 0, 1, 0, 6, 0, 0, 2393.76, 2655.26, 8001.87, 179.609, 0, 3, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 84, 0, 0, 0, 0, 0, 0, 1, 2, 25, 34, 983, 0, 0, 2393.76, 2655.26, 8001.87, 179.609, 0, 3, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 'Mr_Richardson', '8937FB46BC7C1A44E1CFFDE9CBB854950F7AE8FF889CD854418BEDF70E3BECC2D36B5A4E95D809B4C0442FA78E56F5E08666743A97637B2D941D76E42C96A5CD', 1, 99999, 0, 1, 0, 29, '09/30/1996', 'Unknown', 1, 1, 301, 10000000, 48, 0, 0, 0, 0, 0, 0, 1, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 30, 0, 0, 0, 0, 0, 0, 1952.76, -1764.5, 13.2521, 350.04, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 0, 2, 5, 38, 999957, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `audiozones`
--

CREATE TABLE `audiozones` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT 'Audio Zone',
  `url` varchar(255) NOT NULL,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `range` float NOT NULL DEFAULT 30,
  `vw` int(11) NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `enabled` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audiozones`
--

INSERT INTO `audiozones` (`id`, `name`, `url`, `x`, `y`, `z`, `range`, `vw`, `interior`, `enabled`) VALUES
(1, 'Arabic Mix FM', 'https://stream-283.zeno.fm/efx5psd00qruv', 2490.43, -1665.68, 13.3438, 150, 0, 0, 0),
(2, 'Arabic Mix FM', 'https://stream-283.zeno.fm/efx5psd00qruv', 1717.01, -1883.03, 13.5661, 150, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `businesses`
--

CREATE TABLE `businesses` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 1,
  `owner_type` tinyint(4) NOT NULL DEFAULT 0,
  `owner_id` int(11) NOT NULL DEFAULT 0,
  `owner_name` varchar(24) NOT NULL DEFAULT 'Nobody',
  `price` int(11) NOT NULL DEFAULT 250000,
  `price_mode` tinyint(4) NOT NULL DEFAULT 0,
  `materials` int(11) NOT NULL DEFAULT 0,
  `materials_capacity` int(11) NOT NULL DEFAULT 2000,
  `safe_balance` int(11) NOT NULL DEFAULT 0,
  `ext_x` float NOT NULL DEFAULT 0,
  `ext_y` float NOT NULL DEFAULT 0,
  `ext_z` float NOT NULL DEFAULT 0,
  `ext_a` float NOT NULL DEFAULT 0,
  `ext_int` int(11) NOT NULL DEFAULT 0,
  `ext_vw` int(11) NOT NULL DEFAULT 0,
  `int_x` float NOT NULL DEFAULT 0,
  `int_y` float NOT NULL DEFAULT 0,
  `int_z` float NOT NULL DEFAULT 0,
  `int_a` float NOT NULL DEFAULT 0,
  `int_int` int(11) NOT NULL DEFAULT 0,
  `int_vw` int(11) NOT NULL DEFAULT 0,
  `safe_x` float NOT NULL DEFAULT 0,
  `safe_y` float NOT NULL DEFAULT 0,
  `safe_z` float NOT NULL DEFAULT 0,
  `safe_a` float NOT NULL DEFAULT 0,
  `safe_int` int(11) NOT NULL DEFAULT 0,
  `safe_vw` int(11) NOT NULL DEFAULT 0,
  `pickup_model` int(11) NOT NULL DEFAULT 1274,
  `pickup_type` int(11) NOT NULL DEFAULT 1,
  `locked` tinyint(4) NOT NULL DEFAULT 0,
  `lockable` tinyint(4) NOT NULL DEFAULT 1,
  `enterable` tinyint(4) NOT NULL DEFAULT 1,
  `custom_ext` tinyint(4) NOT NULL DEFAULT 0,
  `custom_int` tinyint(4) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `businesses`
--

INSERT INTO `businesses` (`id`, `name`, `type`, `owner_type`, `owner_id`, `owner_name`, `price`, `price_mode`, `materials`, `materials_capacity`, `safe_balance`, `ext_x`, `ext_y`, `ext_z`, `ext_a`, `ext_int`, `ext_vw`, `int_x`, `int_y`, `int_z`, `int_a`, `int_int`, `int_vw`, `safe_x`, `safe_y`, `safe_z`, `safe_a`, `safe_int`, `safe_vw`, `pickup_model`, `pickup_type`, `locked`, `lockable`, `enterable`, `custom_ext`, `custom_int`, `enabled`) VALUES
(1, 'Jimmy\'s 24/7', 1, 1, 1, 'Jimmy_Richardson', 250000, 0, 0, 2000, 60990, 1928.92, -1776.37, 13.5469, 273.368, 0, 0, -25.815, -187.479, 1003.55, 0.195835, 17, 1, -28.8869, -184.74, 1003.55, 355.206, 17, 1, 1272, 23, 0, 1, 1, 0, 0, 1),
(2, '24/7 Store', 1, 0, 0, 'Nobody', 250000, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, -25.8845, -185.869, 1003.55, 0, 17, 2, 0, 0, 0, 0, 0, 0, 1272, 23, 0, 1, 1, 0, 0, 1),
(3, '24/7 Store', 1, 0, 0, 'Nobody', 225000, 0, 0, 2000, 17265, 2513.97, -1691.25, 14.046, 44.0892, 0, 0, -25.8845, -185.869, 1003.55, 0, 17, 3, 0, 0, 0, 0, 0, 0, 1272, 23, 0, 1, 1, 0, 0, 1),
(4, 'Bar / Club', 6, 1, 1, 'Jimmy_Richardson', 225000, 0, 0, 2000, 0, 2309.62, -1643.95, 14.827, 137.616, 0, 0, 501.981, -69.1502, 998.758, 0, 11, 4, 0, 0, 0, 0, 0, 0, 1272, 23, 1, 1, 1, 0, 0, 1),
(5, 'Los Santos Bank', 8, 1, 1, 'Jimmy_Richardson', 4500000, 0, 0, 2000, 19800250, 1459.51, -1010.98, 26.8438, 184.044, 0, 0, 2306.38, -15.2365, 26.7496, 0, 0, 5, 2316.46, -7.46619, 26.7422, 91.2826, 0, 5, 1274, 23, 0, 1, 1, 0, 0, 1),
(6, 'Gym', 9, 0, 0, 'Nobody', 487500, 0, 0, 2000, 1000, 2229.51, -1721.79, 13.5664, 135.036, 0, 0, 772.112, -3.8986, 1000.73, 0, 5, 6, 0, 0, 0, 0, 0, 0, 1272, 23, 0, 1, 1, 0, 0, 1),
(7, 'Clothes Store', 3, 1, 1, 'Jimmy_Richardson', 375000, 0, 0, 2000, 750, 2244.33, -1665.16, 15.4766, 343.854, 0, 0, 204.333, -168.88, 1000.52, 0, 14, 7, 0, 0, 0, 0, 0, 0, 1272, 23, 1, 1, 1, 0, 0, 1),
(8, '24/7 Store', 1, 0, 0, 'Nobody', 3500000, 1, 0, 2000, 25, 2112.34, -1814.57, 14.2569, 133.44, 0, 0, -25.8845, -185.869, 1003.55, 0, 17, 8, 0, 0, 0, 0, 0, 0, 1272, 23, 0, 1, 1, 1, 0, 1),
(9, 'Los Santos Dealership', 5, 1, 1, 'Jimmy_Richardson', 3000000, 0, 0, 2000, 10199500, 1647.85, -1894.23, 13.553, 282.135, 0, 0, -2158.67, 641.518, 1052.38, 0, 1, 9, 562.107, -1286.24, 17.2482, 314.183, 0, 0, 1239, 23, 1, 0, 0, 0, 0, 1),
(10, 'Gun Store', 4, 1, 1, 'Jimmy_Richardson', 1350000, 0, 2000, 2000, 67000, 1368.06, -1279.75, 13.5469, 88.0667, 0, 0, 285.884, -39.016, 1001.52, 0, 1, 10, 0, 0, 0, 0, 0, 0, 1272, 23, 0, 1, 1, 0, 0, 1),
(11, 'Gas Station', 7, 1, 1, 'Jimmy_Richardson', 750000, 0, 0, 2000, 0, 1941.64, -1769.19, 13.6406, 1.84568, 0, 0, -27.3123, -29.2776, 1003.56, 0, 4, 11, 1942.09, -1769.08, 13.6406, 90, 0, 0, 1272, 23, 1, 0, 0, 0, 0, 1),
(12, 'Gun Store', 4, 0, 0, 'Nobody', 900000, 0, 0, 2000, 1500, 2391.98, 2646.25, 8001.15, 116.402, 0, 3, 285.884, -39.016, 1001.52, 0, 1, 12, 0, 0, 0, 0, 0, 0, 1272, 23, 0, 1, 1, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `business_atms`
--

CREATE TABLE `business_atms` (
  `id` int(11) NOT NULL,
  `business_id` int(11) NOT NULL,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `rx` float NOT NULL DEFAULT 0,
  `ry` float NOT NULL DEFAULT 0,
  `rz` float NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `atm_cash` int(11) NOT NULL DEFAULT 0,
  `atm_fees` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `business_atms`
--

INSERT INTO `business_atms` (`id`, `business_id`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `vw`, `interior`, `enabled`, `atm_cash`, `atm_fees`) VALUES
(1, 5, 1462.71, -1010.31, 26.4837, 0, 0, 3.98084, 0, 0, 1, 50000, 0),
(2, 5, 2115.9, -1816.95, 13.911, 1, 0.8, 0.976581, 0, 0, 1, 0, 0),
(3, 5, 1928.62, -1778.85, 13.1861, -0.8, -0.3, 87.0127, 0, 0, 1, 0, 0),
(4, 5, 2324.38, -1644.99, 14.457, 0, 0, -2.94205, 0, 0, 1, 0, 25);

-- --------------------------------------------------------

--
-- Table structure for table `business_products`
--

CREATE TABLE `business_products` (
  `id` int(11) NOT NULL,
  `business_id` int(11) NOT NULL,
  `catalog_id` int(11) NOT NULL,
  `product_name` varchar(64) NOT NULL,
  `product_key` varchar(32) NOT NULL,
  `price` int(11) NOT NULL,
  `min_price` int(11) NOT NULL DEFAULT 1,
  `max_price` int(11) NOT NULL DEFAULT 999999,
  `restock_cost` int(11) NOT NULL DEFAULT 0,
  `material_cost` int(11) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `stock_capacity` int(11) NOT NULL DEFAULT 50,
  `admin_enabled` tinyint(4) NOT NULL DEFAULT 1,
  `owner_enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `business_products`
--

INSERT INTO `business_products` (`id`, `business_id`, `catalog_id`, `product_name`, `product_key`, `price`, `min_price`, `max_price`, `restock_cost`, `material_cost`, `stock`, `stock_capacity`, `admin_enabled`, `owner_enabled`) VALUES
(46, 2, 1, 'Phone', 'phone', 500, 350, 800, 20, 20, 50, 50, 1, 1),
(47, 2, 2, 'Phone Credit', 'phone_credit', 100, 70, 160, 5, 5, 100, 100, 1, 1),
(48, 2, 3, 'Radio', 'radio', 300, 210, 480, 10, 10, 50, 50, 1, 1),
(49, 2, 4, 'MP3 Player', 'mp3', 750, 525, 1200, 20, 20, 50, 50, 1, 1),
(50, 2, 5, 'Rope', 'rope', 100, 70, 160, 5, 5, 50, 50, 1, 1),
(51, 2, 6, 'Sprunk', 'sprunk', 15, 10, 24, 1, 1, 100, 100, 1, 1),
(52, 2, 7, 'Mask', 'mask', 300, 210, 480, 15, 15, 50, 50, 1, 1),
(53, 2, 8, 'Camera', 'camera', 200, 140, 320, 10, 10, 50, 50, 1, 1),
(54, 2, 9, 'Repair Kit', 'repairkit', 800, 560, 1280, 40, 40, 25, 25, 1, 1),
(55, 2, 10, 'GPS', 'gps', 500, 350, 800, 25, 25, 50, 50, 1, 1),
(61, 1, 1, 'Phone', 'phone', 500, 350, 800, 20, 20, 1050, 50, 1, 1),
(62, 1, 2, 'Phone Credit', 'phone_credit', 100, 70, 160, 5, 5, 100, 100, 1, 1),
(63, 1, 3, 'Radio', 'radio', 300, 210, 480, 10, 10, 50, 50, 1, 1),
(64, 1, 4, 'MP3 Player', 'mp3', 750, 525, 1200, 20, 20, 50, 50, 1, 1),
(65, 1, 5, 'Rope', 'rope', 100, 70, 160, 5, 5, 48, 50, 1, 1),
(66, 1, 6, 'Sprunk', 'sprunk', 15, 10, 24, 1, 1, 98, 100, 1, 1),
(67, 1, 7, 'Mask', 'mask', 300, 210, 480, 15, 15, 50, 50, 1, 1),
(68, 1, 8, 'Camera', 'camera', 200, 140, 320, 10, 10, 50, 50, 1, 1),
(69, 1, 9, 'Repair Kit', 'repairkit', 800, 560, 1280, 40, 40, 25, 25, 1, 1),
(70, 1, 10, 'GPS', 'gps', 500, 350, 800, 25, 25, 50, 50, 1, 1),
(94, 4, 25, 'Beer', 'beer', 10, 21, 48, 2, 2, 1100, 100, 1, 1),
(95, 4, 26, 'Wine', 'wine', 60, 42, 96, 3, 3, 100, 100, 1, 1),
(96, 4, 27, 'Sprunk', 'sprunk', 15, 10, 24, 1, 1, 100, 100, 1, 1),
(97, 6, 32, 'Gym Membership', 'gym_membership', 500, 350, 800, 0, 0, 100, 100, 1, 1),
(98, 6, 33, 'Strength Training', 'strength_training', 1000, 700, 1600, 0, 0, 99, 100, 1, 1),
(100, 7, 17, 'Clothes', 'clothes', 500, 350, 800, 25, 25, 100, 100, 1, 1),
(101, 7, 18, 'Toys', 'toys', 1000, 700, 1600, 50, 50, 100, 100, 1, 1),
(110, 8, 1, 'Phone', 'phone', 500, 350, 800, 20, 20, 50, 50, 1, 1),
(111, 8, 2, 'Phone Credit', 'phone_credit', 100, 70, 160, 5, 5, 100, 100, 1, 1),
(112, 8, 3, 'Radio', 'radio', 300, 210, 480, 10, 10, 50, 50, 1, 1),
(113, 8, 4, 'MP3 Player', 'mp3', 750, 525, 1200, 20, 20, 50, 50, 1, 1),
(114, 8, 5, 'Rope', 'rope', 100, 70, 160, 5, 5, 50, 50, 1, 1),
(115, 8, 6, 'Sprunk', 'sprunk', 15, 10, 24, 1, 1, 100, 100, 1, 1),
(116, 8, 7, 'Mask', 'mask', 300, 210, 480, 15, 15, 50, 50, 1, 1),
(117, 8, 8, 'Camera', 'camera', 200, 140, 320, 10, 10, 50, 50, 1, 1),
(118, 8, 9, 'Repair Kit', 'repairkit', 800, 560, 1280, 40, 40, 25, 25, 1, 1),
(119, 8, 10, 'GPS', 'gps', 500, 350, 800, 25, 25, 50, 50, 1, 1),
(125, 10, 19, 'Colt 45', 'weapon_22', 500000, 1050, 2400, 100, 100, 20, 20, 1, 1),
(126, 10, 20, 'Silenced Pistol', 'weapon_23', 2500, 1750, 4000, 150, 150, 39, 20, 1, 1),
(127, 10, 21, 'Shotgun', 'weapon_25', 4500, 3150, 7200, 300, 300, 8, 15, 1, 1),
(128, 10, 22, 'Rifle', 'weapon_33', 6500, 4550, 10400, 500, 500, 6, 10, 1, 1),
(129, 10, 23, 'Ammo Pack', 'ammo_pack', 500, 350, 800, 50, 50, 49, 50, 0, 0),
(130, 10, 24, 'Armor 50', 'armor_50', 1000, 700, 1600, 250, 250, 18, 20, 1, 1),
(132, 3, 1, 'Phone', 'phone', 500, 350, 800, 20, 20, 50, 50, 1, 1),
(133, 3, 2, 'Phone Credit', 'phone_credit', 100, 70, 160, 5, 5, 100, 100, 1, 1),
(134, 3, 3, 'Radio', 'radio', 300, 210, 480, 10, 10, 49, 50, 1, 1),
(135, 3, 4, 'MP3 Player', 'mp3', 750, 525, 1200, 20, 20, 49, 50, 1, 1),
(136, 3, 5, 'Rope', 'rope', 100, 70, 160, 5, 5, 50, 50, 1, 1),
(137, 3, 6, 'Sprunk', 'sprunk', 15, 10, 24, 1, 1, 99, 100, 1, 1),
(138, 3, 7, 'Mask', 'mask', 300, 210, 480, 15, 15, 50, 50, 1, 1),
(139, 3, 8, 'Camera', 'camera', 200, 140, 320, 10, 10, 49, 50, 1, 1),
(140, 3, 9, 'Repair Kit', 'repairkit', 800, 560, 1280, 40, 40, 25, 25, 1, 1),
(141, 3, 10, 'GPS', 'gps', 500, 350, 800, 25, 25, 50, 50, 1, 1),
(147, 3, 12, 'Vehicle Alarm', 'vehlock_alarm', 5000, 3500, 8000, 50, 50, 20, 20, 1, 1),
(148, 3, 13, 'Industrial Vehicle Lock', 'vehlock_industrial', 15000, 10500, 24000, 150, 150, 19, 20, 1, 1),
(150, 1, 12, 'Vehicle Alarm', 'vehlock_alarm', 5000, 3500, 8000, 50, 50, 20, 20, 1, 1),
(151, 1, 13, 'Industrial Vehicle Lock', 'vehlock_industrial', 15000, 10500, 24000, 150, 150, 19, 20, 1, 1),
(153, 1, 52, 'Cigar', 'cigar', 50, 35, 80, 1, 1, 99, 100, 1, 1),
(154, 2, 12, 'Vehicle Alarm', 'vehlock_alarm', 5000, 3500, 8000, 50, 50, 20, 20, 1, 1),
(155, 8, 12, 'Vehicle Alarm', 'vehlock_alarm', 5000, 3500, 8000, 50, 50, 20, 20, 1, 1),
(156, 2, 13, 'Industrial Vehicle Lock', 'vehlock_industrial', 15000, 10500, 24000, 150, 150, 20, 20, 1, 1),
(157, 8, 13, 'Industrial Vehicle Lock', 'vehlock_industrial', 15000, 10500, 24000, 150, 150, 20, 20, 1, 1),
(158, 2, 52, 'Cigar', 'cigar', 50, 35, 80, 1, 1, 100, 100, 1, 1),
(159, 3, 52, 'Cigar', 'cigar', 50, 35, 80, 1, 1, 100, 100, 1, 1),
(160, 8, 52, 'Cigar', 'cigar', 50, 35, 80, 1, 1, 100, 100, 1, 1),
(161, 1, 53, '10 Hotwire Tools', 'hotwire_tool', 1500, 1200, 2500, 800, 800, 76, 25, 1, 1),
(162, 2, 53, '10 Hotwire Tools', 'hotwire_tool', 1500, 1200, 2500, 800, 800, 25, 25, 1, 1),
(163, 3, 53, '10 Hotwire Tools', 'hotwire_tool', 1500, 1200, 2500, 800, 800, 25, 25, 1, 1),
(164, 8, 53, '10 Hotwire Tools', 'hotwire_tool', 1500, 1200, 2500, 800, 800, 25, 25, 1, 1),
(169, 11, 28, 'Fuel Can', 'fuelcan', 250, 175, 400, 15, 15, 61, 50, 0, 0),
(170, 11, 29, 'Repair Kit', 'repairkit', 800, 560, 1280, 40, 40, 25, 25, 0, 0),
(171, 11, 30, 'Oil', 'oil', 150, 105, 240, 10, 10, 50, 50, 0, 0),
(172, 11, 31, 'Sprunk', 'sprunk', 15, 10, 24, 1, 1, 100, 100, 0, 0),
(173, 11, 50, 'Vehicle Alarm', 'vehlock_alarm', 5000, 3500, 8000, 50, 50, 20, 20, 0, 0),
(174, 11, 51, 'Industrial Vehicle Lock', 'vehlock_industrial', 15000, 10500, 24000, 150, 150, 20, 20, 0, 0),
(176, 12, 19, 'Colt 45', 'weapon_22', 1500, 1050, 2400, 100, 100, 19, 20, 1, 1),
(177, 12, 20, 'Silenced Pistol', 'weapon_23', 2500, 1750, 4000, 150, 150, 20, 20, 1, 1),
(178, 12, 21, 'Shotgun', 'weapon_25', 4500, 3150, 7200, 300, 300, 15, 15, 1, 1),
(179, 12, 22, 'Rifle', 'weapon_33', 6500, 4550, 10400, 500, 500, 10, 10, 1, 1),
(180, 12, 24, 'Armor 50', 'armor_50', 1000, 700, 1600, 250, 250, 20, 20, 1, 1),
(181, 11, 55, 'Gas', 'gas', 10, 1, 15, 8, 0, 219, 500, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `business_product_catalog`
--

CREATE TABLE `business_product_catalog` (
  `id` int(11) NOT NULL,
  `business_type` int(11) NOT NULL,
  `product_name` varchar(64) NOT NULL,
  `product_key` varchar(32) NOT NULL,
  `price` int(11) NOT NULL,
  `min_price` int(11) NOT NULL DEFAULT 1,
  `max_price` int(11) NOT NULL DEFAULT 999999,
  `restock_cost` int(11) NOT NULL DEFAULT 0,
  `material_cost` int(11) NOT NULL,
  `default_stock_capacity` int(11) NOT NULL DEFAULT 50,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `business_product_catalog`
--

INSERT INTO `business_product_catalog` (`id`, `business_type`, `product_name`, `product_key`, `price`, `min_price`, `max_price`, `restock_cost`, `material_cost`, `default_stock_capacity`, `enabled`) VALUES
(1, 1, 'Phone', 'phone', 500, 350, 800, 20, 20, 50, 1),
(2, 1, 'Phone Credit', 'phone_credit', 100, 70, 160, 5, 5, 100, 1),
(3, 1, 'Radio', 'radio', 300, 210, 480, 10, 10, 50, 1),
(4, 1, 'MP3 Player', 'mp3', 750, 525, 1200, 20, 20, 50, 1),
(5, 1, 'Rope', 'rope', 100, 70, 160, 5, 5, 50, 1),
(6, 1, 'Sprunk', 'sprunk', 15, 10, 24, 1, 1, 100, 1),
(7, 1, 'Mask', 'mask', 300, 210, 480, 15, 15, 50, 1),
(8, 1, 'Camera', 'camera', 200, 140, 320, 10, 10, 50, 1),
(9, 1, 'Repair Kit', 'repairkit', 800, 560, 1280, 40, 40, 25, 1),
(10, 1, 'GPS', 'gps', 500, 350, 800, 25, 25, 50, 1),
(11, 2, 'Burger', 'burger', 25, 17, 40, 2, 2, 100, 1),
(12, 1, 'Vehicle Alarm', 'vehlock_alarm', 5000, 3500, 8000, 50, 50, 20, 1),
(13, 1, 'Industrial Vehicle Lock', 'vehlock_industrial', 15000, 10500, 24000, 150, 150, 20, 1),
(14, 2, 'Water', 'water', 10, 7, 16, 1, 1, 100, 1),
(15, 2, 'Sprunk', 'sprunk', 15, 10, 24, 1, 1, 100, 1),
(16, 2, 'Coffee', 'coffee', 10, 7, 16, 1, 1, 100, 1),
(17, 3, 'Clothes', 'clothes', 500, 350, 800, 25, 25, 100, 1),
(18, 3, 'Toys', 'toys', 1000, 700, 1600, 50, 50, 100, 1),
(19, 4, 'Colt 45', 'weapon_22', 1500, 1050, 2400, 100, 100, 20, 1),
(20, 4, 'Silenced Pistol', 'weapon_23', 2500, 1750, 4000, 150, 150, 20, 1),
(21, 4, 'Shotgun', 'weapon_25', 4500, 3150, 7200, 300, 300, 15, 1),
(22, 4, 'Rifle', 'weapon_33', 6500, 4550, 10400, 500, 500, 10, 1),
(23, 4, 'Ammo Pack', 'ammo_pack', 500, 350, 800, 50, 50, 50, 0),
(24, 4, 'Armor 50', 'armor_50', 1000, 700, 1600, 250, 250, 20, 1),
(25, 6, 'Beer', 'beer', 30, 21, 48, 2, 2, 100, 1),
(26, 6, 'Wine', 'wine', 60, 42, 96, 3, 3, 100, 1),
(27, 6, 'Sprunk', 'sprunk', 15, 10, 24, 1, 1, 100, 1),
(28, 7, 'Fuel Can', 'fuelcan', 250, 175, 400, 15, 15, 50, 0),
(29, 7, 'Repair Kit', 'repairkit', 800, 560, 1280, 40, 40, 25, 0),
(30, 7, 'Oil', 'oil', 150, 105, 240, 10, 10, 50, 0),
(31, 7, 'Sprunk', 'sprunk', 15, 10, 24, 1, 1, 100, 0),
(32, 9, 'Gym Membership', 'gym_membership', 500, 350, 800, 0, 0, 100, 1),
(33, 9, 'Strength Training', 'strength_training', 1000, 700, 1600, 0, 0, 100, 1),
(50, 7, 'Vehicle Alarm', 'vehlock_alarm', 5000, 3500, 8000, 50, 50, 20, 0),
(51, 7, 'Industrial Vehicle Lock', 'vehlock_industrial', 15000, 10500, 24000, 150, 150, 20, 0),
(52, 1, 'Cigar', 'cigar', 50, 35, 80, 1, 1, 100, 1),
(53, 1, '10 Hotwire Tools', 'hotwire_tool', 1500, 1200, 2500, 800, 800, 25, 1),
(54, 7, 'Fuel Can', 'fuel_can', 250, 100, 1000, 100, 0, 50, 0),
(55, 7, 'Gas', 'gas', 25, 1, 500, 10, 0, 5000, 1);

-- --------------------------------------------------------

--
-- Table structure for table `dealership_vehicles`
--

CREATE TABLE `dealership_vehicles` (
  `id` int(11) NOT NULL,
  `business_id` int(11) NOT NULL,
  `veh_modelid` int(11) NOT NULL,
  `veh_name` varchar(32) NOT NULL,
  `color1` int(11) NOT NULL DEFAULT 0,
  `color2` int(11) NOT NULL DEFAULT 0,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `a` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  `material_cost` int(11) NOT NULL DEFAULT 0,
  `stock` int(11) NOT NULL DEFAULT 0,
  `stock_capacity` int(11) NOT NULL DEFAULT 10,
  `spawn_x` float NOT NULL DEFAULT 0,
  `spawn_y` float NOT NULL DEFAULT 0,
  `spawn_z` float NOT NULL DEFAULT 0,
  `spawn_a` float NOT NULL DEFAULT 0,
  `spawn_int` int(11) NOT NULL DEFAULT 0,
  `spawn_vw` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `paintjob` int(11) NOT NULL DEFAULT -1,
  `nos` int(11) NOT NULL DEFAULT 0,
  `unlimited_nos` int(11) NOT NULL DEFAULT 0,
  `mod_spoiler` int(11) NOT NULL DEFAULT 0,
  `mod_hood` int(11) NOT NULL DEFAULT 0,
  `mod_roof` int(11) NOT NULL DEFAULT 0,
  `mod_sideskirt_l` int(11) NOT NULL DEFAULT 0,
  `mod_sideskirt_r` int(11) NOT NULL DEFAULT 0,
  `mod_lamps` int(11) NOT NULL DEFAULT 0,
  `mod_nitro` int(11) NOT NULL DEFAULT 0,
  `mod_exhaust` int(11) NOT NULL DEFAULT 0,
  `mod_wheels` int(11) NOT NULL DEFAULT 0,
  `mod_stereo` int(11) NOT NULL DEFAULT 0,
  `mod_hydraulics` int(11) NOT NULL DEFAULT 0,
  `mod_front_bumper` int(11) NOT NULL DEFAULT 0,
  `mod_rear_bumper` int(11) NOT NULL DEFAULT 0,
  `mod_vent_right` int(11) NOT NULL DEFAULT 0,
  `mod_vent_left` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dealership_vehicles`
--

INSERT INTO `dealership_vehicles` (`id`, `business_id`, `veh_modelid`, `veh_name`, `color1`, `color2`, `x`, `y`, `z`, `a`, `interior`, `vw`, `price`, `material_cost`, `stock`, `stock_capacity`, `spawn_x`, `spawn_y`, `spawn_z`, `spawn_a`, `spawn_int`, `spawn_vw`, `enabled`, `paintjob`, `nos`, `unlimited_nos`, `mod_spoiler`, `mod_hood`, `mod_roof`, `mod_sideskirt_l`, `mod_sideskirt_r`, `mod_lamps`, `mod_nitro`, `mod_exhaust`, `mod_wheels`, `mod_stereo`, `mod_hydraulics`, `mod_front_bumper`, `mod_rear_bumper`, `mod_vent_right`, `mod_vent_left`) VALUES
(1, 9, 560, 'Sultan', 0, 0, 1638.24, -1908.52, 13.5521, 334.02, 0, 0, 100000, 0, 8, 10, 1638.88, -1888.35, 13.5549, 3.26471, 0, 0, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 9, 466, 'Glendale', 0, 0, 1633.01, -1902.52, 13.5526, 313.351, 0, 0, 1500, 0, 7, 10, 1646.63, -1894.39, 13.2367, 322.203, 0, 0, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 9, 562, 'Elegy', 0, 0, 1635.2, -1905.68, 13.5505, 322.414, 0, 0, 2500, 0, 0, 10, 1646.63, -1894.39, 13.2367, 322.203, 0, 0, 1, -1, 0, 1, 1146, 0, 1035, 1039, 1041, 0, 0, 1037, 0, 0, 0, 1171, 1148, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `doors`
--

CREATE TABLE `doors` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT 'Door',
  `owner_type` tinyint(4) NOT NULL DEFAULT 0,
  `owner_id` int(11) NOT NULL DEFAULT 0,
  `lock_rank` tinyint(4) NOT NULL DEFAULT 0,
  `family_crew` int(11) NOT NULL DEFAULT 0,
  `faction_division` int(11) NOT NULL DEFAULT 0,
  `vip_level` int(11) NOT NULL DEFAULT 0,
  `admin_level` int(11) NOT NULL DEFAULT 0,
  `ext_x` float NOT NULL DEFAULT 0,
  `ext_y` float NOT NULL DEFAULT 0,
  `ext_z` float NOT NULL DEFAULT 0,
  `ext_a` float NOT NULL DEFAULT 0,
  `ext_int` int(11) NOT NULL DEFAULT 0,
  `ext_vw` int(11) NOT NULL DEFAULT 0,
  `int_x` float NOT NULL DEFAULT 0,
  `int_y` float NOT NULL DEFAULT 0,
  `int_z` float NOT NULL DEFAULT 0,
  `int_a` float NOT NULL DEFAULT 0,
  `int_int` int(11) NOT NULL DEFAULT 0,
  `int_vw` int(11) NOT NULL DEFAULT 0,
  `pickup_model` int(11) NOT NULL DEFAULT 1318,
  `pickup_type` int(11) NOT NULL DEFAULT 1,
  `lockable` tinyint(4) NOT NULL DEFAULT 0,
  `locked` tinyint(4) NOT NULL DEFAULT 0,
  `custom_ext` tinyint(4) NOT NULL DEFAULT 0,
  `custom_int` tinyint(4) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doors`
--

INSERT INTO `doors` (`id`, `name`, `owner_type`, `owner_id`, `lock_rank`, `family_crew`, `faction_division`, `vip_level`, `admin_level`, `ext_x`, `ext_y`, `ext_z`, `ext_a`, `ext_int`, `ext_vw`, `int_x`, `int_y`, `int_z`, `int_a`, `int_int`, `int_vw`, `pickup_model`, `pickup_type`, `lockable`, `locked`, `custom_ext`, `custom_int`, `enabled`) VALUES
(1, 'Drug House', 0, 0, 0, 0, 0, 0, 0, 2165.95, -1671.33, 15.0733, 225.308, 0, 1, 2165.95, -1671.33, 15.0733, 225.308, 0, 1, 1318, 1, 0, 0, 0, 0, 1),
(2, 'All Saints Hospital', 0, 0, 0, 0, 0, 0, 0, 1172.64, -1323.35, 15.403, 271.326, 0, 0, 1169.73, -1356.06, 2423.05, 0.529711, 0, 2, 1318, 1, 0, 0, 0, 1, 1),
(3, 'County Hospital', 0, 0, 0, 0, 0, 0, 0, 2034.14, -1402.85, 17.2945, 180.391, 0, 0, 2383.18, 2664.95, 8001.15, 182.22, 0, 3, 1318, 1, 0, 0, 0, 1, 1),
(4, 'Jimmy\'s', 0, 0, 0, 0, 0, 0, 0, 1183.67, -1324.74, 13.5766, 86.9093, 0, 0, 1183.67, -1324.74, 13.5766, 86.9093, 0, 4, 1318, 1, 0, 0, 0, 0, 1),
(5, 'House Backyard', 0, 0, 0, 0, 0, 0, 0, 2470.1, -1698.34, 13.516, 271.795, 0, 0, 1169.75, -1356.2, 2423.05, 354.218, 0, 3, 1318, 1, 0, 0, 0, 0, 1),
(6, 'LSPD', 0, 0, 0, 0, 0, 0, 0, 1555.21, -1675.59, 16.1953, 89.9618, 0, 0, 1555.21, -1675.59, 16.1953, 89.9618, 0, 6, 1318, 1, 0, 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `factions`
--

CREATE TABLE `factions` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `type` tinyint(4) NOT NULL DEFAULT 0,
  `leader_id` int(11) NOT NULL DEFAULT 0,
  `leader_name` varchar(24) NOT NULL DEFAULT 'Nobody',
  `members_count` int(11) NOT NULL DEFAULT 0,
  `motd` varchar(128) NOT NULL DEFAULT '',
  `set_motd_rank` tinyint(4) NOT NULL DEFAULT 5,
  `invite_kick_rank` tinyint(4) NOT NULL DEFAULT 5,
  `point_capture_rank` tinyint(4) NOT NULL DEFAULT 5,
  `turf_capture_rank` tinyint(4) NOT NULL DEFAULT 5,
  `safe_balance` int(11) NOT NULL DEFAULT 0,
  `enabled` int(11) NOT NULL DEFAULT 1,
  `safe_deposit_rank` int(11) NOT NULL DEFAULT 1,
  `safe_withdraw_rank` int(11) NOT NULL DEFAULT 6,
  `locker_deposit_rank` int(11) NOT NULL DEFAULT 1,
  `locker_withdraw_rank` int(11) NOT NULL DEFAULT 6,
  `locker_gun_rank` int(11) NOT NULL DEFAULT 1,
  `color` int(11) NOT NULL DEFAULT 865730559,
  `radio_color` int(11) NOT NULL DEFAULT 865730559,
  `division_color` int(11) NOT NULL DEFAULT 16776960,
  `vehicle_lock_rank` int(11) NOT NULL DEFAULT 5,
  `vehicle_track_rank` int(11) NOT NULL DEFAULT 5,
  `vehicle_park_rank` int(11) NOT NULL DEFAULT 5,
  `business_safe_deposit_rank` int(11) NOT NULL DEFAULT 5,
  `business_safe_withdraw_rank` int(11) NOT NULL DEFAULT 5,
  `business_restock_rank` int(11) NOT NULL DEFAULT 5,
  `business_lock_rank` int(11) NOT NULL DEFAULT 5,
  `door_lock_rank` int(11) NOT NULL DEFAULT 5
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `factions`
--

INSERT INTO `factions` (`id`, `name`, `type`, `leader_id`, `leader_name`, `members_count`, `motd`, `set_motd_rank`, `invite_kick_rank`, `point_capture_rank`, `turf_capture_rank`, `safe_balance`, `enabled`, `safe_deposit_rank`, `safe_withdraw_rank`, `locker_deposit_rank`, `locker_withdraw_rank`, `locker_gun_rank`, `color`, `radio_color`, `division_color`, `vehicle_lock_rank`, `vehicle_track_rank`, `vehicle_park_rank`, `business_safe_deposit_rank`, `business_safe_withdraw_rank`, `business_restock_rank`, `business_lock_rank`, `door_lock_rank`) VALUES
(1, 'LSPD', 1, 0, 'Nobody', 0, 'Welcome to the faction.', 5, 5, 5, 5, 0, 1, 1, 5, 1, 5, 1, 869072895, 869072895, -65281, 5, 5, 5, 5, 5, 5, 5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `faction_divisions`
--

CREATE TABLE `faction_divisions` (
  `id` int(11) NOT NULL,
  `faction_id` int(11) NOT NULL,
  `division_id` int(11) NOT NULL,
  `division_name` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faction_divisions`
--

INSERT INTO `faction_divisions` (`id`, `faction_id`, `division_id`, `division_name`) VALUES
(1, 1, 1, 'Patrol Division'),
(2, 1, 2, 'Investigations Division'),
(3, 1, 3, 'Command Division');

-- --------------------------------------------------------

--
-- Table structure for table `faction_lockers`
--

CREATE TABLE `faction_lockers` (
  `id` int(11) NOT NULL,
  `faction_id` int(11) NOT NULL,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `a` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `materials` int(11) NOT NULL DEFAULT 0,
  `pot` int(11) NOT NULL DEFAULT 0,
  `crack` int(11) NOT NULL DEFAULT 0,
  `enabled` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faction_lockers`
--

INSERT INTO `faction_lockers` (`id`, `faction_id`, `x`, `y`, `z`, `a`, `interior`, `vw`, `materials`, `pot`, `crack`, `enabled`) VALUES
(1, 1, 2103.01, -1747.14, 13.1189, 0, 0, 0, 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `faction_locker_guns`
--

CREATE TABLE `faction_locker_guns` (
  `id` int(11) NOT NULL,
  `locker_id` int(11) NOT NULL,
  `weaponid` int(11) NOT NULL,
  `required_rank` tinyint(4) NOT NULL DEFAULT 1,
  `required_division` int(11) NOT NULL DEFAULT 0,
  `admin_enabled` int(11) NOT NULL DEFAULT 1,
  `leader_enabled` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faction_locker_guns`
--

INSERT INTO `faction_locker_guns` (`id`, `locker_id`, `weaponid`, `required_rank`, `required_division`, `admin_enabled`, `leader_enabled`) VALUES
(1, 1, 22, 1, 0, 1, 1),
(2, 1, 23, 1, 0, 1, 1),
(3, 1, 24, 1, 0, 1, 1),
(4, 1, 25, 4, 0, 1, 1),
(5, 1, 29, 4, 0, 1, 1),
(6, 1, 30, 4, 0, 1, 1),
(7, 1, 31, 5, 0, 1, 1),
(8, 1, 33, 5, 0, 1, 1),
(9, 1, 34, 5, 0, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `faction_ranks`
--

CREATE TABLE `faction_ranks` (
  `id` int(11) NOT NULL,
  `faction_id` int(11) NOT NULL,
  `rank_id` int(11) NOT NULL,
  `rank_name` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faction_ranks`
--

INSERT INTO `faction_ranks` (`id`, `faction_id`, `rank_id`, `rank_name`) VALUES
(1, 1, 1, 'Recruit'),
(2, 1, 2, 'Officer'),
(3, 1, 3, 'Senior Officer'),
(4, 1, 4, 'Sergeant'),
(5, 1, 5, 'Lieutenant'),
(6, 1, 6, 'Chief');

-- --------------------------------------------------------

--
-- Table structure for table `faction_safes`
--

CREATE TABLE `faction_safes` (
  `id` int(11) NOT NULL,
  `faction_id` int(11) NOT NULL,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `a` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `balance` int(11) NOT NULL DEFAULT 0,
  `enabled` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `families`
--

CREATE TABLE `families` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `leader_id` int(11) NOT NULL DEFAULT 0,
  `leader_name` varchar(24) NOT NULL DEFAULT 'Nobody',
  `members_count` int(11) NOT NULL DEFAULT 0,
  `motd` varchar(128) NOT NULL DEFAULT '',
  `set_motd_rank` tinyint(4) NOT NULL DEFAULT 5,
  `invite_kick_rank` tinyint(4) NOT NULL DEFAULT 5,
  `point_capture_rank` tinyint(4) NOT NULL DEFAULT 5,
  `turf_capture_rank` tinyint(4) NOT NULL DEFAULT 5,
  `safe_deposit_rank` int(11) NOT NULL DEFAULT 1,
  `safe_withdraw_rank` int(11) NOT NULL DEFAULT 6,
  `locker_deposit_rank` int(11) NOT NULL DEFAULT 1,
  `locker_withdraw_rank` int(11) NOT NULL DEFAULT 6,
  `locker_gun_rank` int(11) NOT NULL DEFAULT 1,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `color` int(11) NOT NULL DEFAULT 869020671,
  `radio_color` int(11) NOT NULL DEFAULT 869020671,
  `crew_color` int(11) NOT NULL DEFAULT 16776960,
  `vehicle_lock_rank` int(11) NOT NULL DEFAULT 5,
  `vehicle_track_rank` int(11) NOT NULL DEFAULT 5,
  `vehicle_park_rank` int(11) NOT NULL DEFAULT 5,
  `business_safe_deposit_rank` int(11) NOT NULL DEFAULT 5,
  `business_safe_withdraw_rank` int(11) NOT NULL DEFAULT 5,
  `business_restock_rank` int(11) NOT NULL DEFAULT 5,
  `business_lock_rank` int(11) NOT NULL DEFAULT 5,
  `door_lock_rank` int(11) NOT NULL DEFAULT 5
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `families`
--

INSERT INTO `families` (`id`, `name`, `leader_id`, `leader_name`, `members_count`, `motd`, `set_motd_rank`, `invite_kick_rank`, `point_capture_rank`, `turf_capture_rank`, `safe_deposit_rank`, `safe_withdraw_rank`, `locker_deposit_rank`, `locker_withdraw_rank`, `locker_gun_rank`, `enabled`, `color`, `radio_color`, `crew_color`, `vehicle_lock_rank`, `vehicle_track_rank`, `vehicle_park_rank`, `business_safe_deposit_rank`, `business_safe_withdraw_rank`, `business_restock_rank`, `business_lock_rank`, `door_lock_rank`) VALUES
(1, 'Groove Street Families', 0, 'Nobody', 1, 'Welcome to the family.', 5, 5, 5, 5, 1, 5, 1, 5, 1, 1, 869020671, 16777215, 16777215, 5, 5, 5, 5, 5, 5, 5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `family_crews`
--

CREATE TABLE `family_crews` (
  `id` int(11) NOT NULL,
  `family_id` int(11) NOT NULL,
  `crew_id` int(11) NOT NULL,
  `crew_name` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `family_crews`
--

INSERT INTO `family_crews` (`id`, `family_id`, `crew_id`, `crew_name`) VALUES
(1, 1, 1, 'Main Crew'),
(2, 1, 2, 'Street Crew'),
(3, 1, 3, 'Business Crew');

-- --------------------------------------------------------

--
-- Table structure for table `family_lockers`
--

CREATE TABLE `family_lockers` (
  `id` int(11) NOT NULL,
  `family_id` int(11) NOT NULL,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `materials` int(11) NOT NULL DEFAULT 10000,
  `pot` int(11) NOT NULL DEFAULT 0,
  `crack` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `family_lockers`
--

INSERT INTO `family_lockers` (`id`, `family_id`, `x`, `y`, `z`, `interior`, `vw`, `materials`, `pot`, `crack`, `enabled`) VALUES
(1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `family_locker_guns`
--

CREATE TABLE `family_locker_guns` (
  `id` int(11) NOT NULL,
  `locker_id` int(11) NOT NULL,
  `weaponid` int(11) NOT NULL,
  `required_rank` tinyint(4) NOT NULL DEFAULT 1,
  `required_crew` int(11) NOT NULL DEFAULT 0,
  `admin_enabled` tinyint(4) NOT NULL DEFAULT 1,
  `leader_enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `family_locker_guns`
--

INSERT INTO `family_locker_guns` (`id`, `locker_id`, `weaponid`, `required_rank`, `required_crew`, `admin_enabled`, `leader_enabled`) VALUES
(1, 1, 22, 1, 0, 1, 1),
(2, 1, 23, 1, 0, 1, 1),
(3, 1, 24, 1, 0, 1, 1),
(4, 1, 25, 4, 0, 1, 1),
(5, 1, 29, 4, 0, 1, 1),
(6, 1, 30, 4, 0, 1, 1),
(7, 1, 31, 5, 0, 1, 1),
(8, 1, 33, 5, 0, 1, 1),
(9, 1, 34, 5, 0, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `family_ranks`
--

CREATE TABLE `family_ranks` (
  `id` int(11) NOT NULL,
  `family_id` int(11) NOT NULL,
  `rank_id` int(11) NOT NULL,
  `rank_name` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `family_ranks`
--

INSERT INTO `family_ranks` (`id`, `family_id`, `rank_id`, `rank_name`) VALUES
(1, 1, 1, 'Outsider'),
(2, 1, 2, 'Associate'),
(3, 1, 3, 'Soldier'),
(4, 1, 4, 'Captain'),
(5, 1, 5, 'Underboss'),
(6, 1, 6, 'Leader');

-- --------------------------------------------------------

--
-- Table structure for table `family_safes`
--

CREATE TABLE `family_safes` (
  `id` int(11) NOT NULL,
  `family_id` int(11) NOT NULL,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `balance` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gas_pumps`
--

CREATE TABLE `gas_pumps` (
  `id` int(11) NOT NULL,
  `business_id` int(11) NOT NULL,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `x2` float NOT NULL DEFAULT 0,
  `y2` float NOT NULL DEFAULT 0,
  `z2` float NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gas_pumps`
--

INSERT INTO `gas_pumps` (`id`, `business_id`, `x`, `y`, `z`, `x2`, `y2`, `z2`, `vw`, `interior`, `enabled`) VALUES
(1, 11, 1941.61, -1775.8, 13.6406, 1941.51, -1769.38, 13.6406, 0, 0, 1),
(2, 11, 1944.33, -1755.46, 13.0668, 1944.36, -1757.26, 13.0672, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `gates`
--

CREATE TABLE `gates` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT 'Gate',
  `model` int(11) NOT NULL DEFAULT 980,
  `closed_x` float NOT NULL DEFAULT 0,
  `closed_y` float NOT NULL DEFAULT 0,
  `closed_z` float NOT NULL DEFAULT 0,
  `closed_rx` float NOT NULL DEFAULT 0,
  `closed_ry` float NOT NULL DEFAULT 0,
  `closed_rz` float NOT NULL DEFAULT 0,
  `open_x` float NOT NULL DEFAULT 0,
  `open_y` float NOT NULL DEFAULT 0,
  `open_z` float NOT NULL DEFAULT 0,
  `open_rx` float NOT NULL DEFAULT 0,
  `open_ry` float NOT NULL DEFAULT 0,
  `open_rz` float NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `owner_type` tinyint(4) NOT NULL DEFAULT 0,
  `owner_id` int(11) NOT NULL DEFAULT 0,
  `rank` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `range` float NOT NULL DEFAULT 5,
  `move_speed` float NOT NULL DEFAULT 2
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gates`
--

INSERT INTO `gates` (`id`, `name`, `model`, `closed_x`, `closed_y`, `closed_z`, `closed_rx`, `closed_ry`, `closed_rz`, `open_x`, `open_y`, `open_z`, `open_rx`, `open_ry`, `open_rz`, `vw`, `interior`, `owner_type`, `owner_id`, `rank`, `enabled`, `range`, `move_speed`) VALUES
(1, 'LSPD', 983, 1544.7, -1627.31, 13.0228, 0, 0, -179.981, 1544.7, -1627.31, 11.6228, 0, 0, -179.981, 0, 0, 0, 0, 7, 1, 5, 2),
(2, 'Groove', 19912, 2379.88, -1759.5, 14.7907, 0, 0, -0.864007, 2379.88, -1759.5, 9.7107, 0, 0, -0.864007, 0, 0, 0, 0, 0, 1, 12, 2),
(3, 'Grove', 19870, 2261.65, -1759.87, 14.3381, 0, 0, 179.709, 2261.65, -1759.87, 10.7581, 0, 0, 179.709, 0, 0, 0, 0, 0, 1, 5, 2),
(4, 'Grove', 19870, 2267.92, -1759.9, 14.3381, 0, 0, 179.709, 2267.92, -1759.9, 10.7681, 0, 0, 179.709, 0, 0, 0, 0, 0, 1, 5, 2);

-- --------------------------------------------------------

--
-- Table structure for table `hospitals`
--

CREATE TABLE `hospitals` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `city` int(11) NOT NULL DEFAULT 0,
  `city_name` varchar(32) NOT NULL DEFAULT 'Los Santos',
  `insurance_x` float NOT NULL DEFAULT 0,
  `insurance_y` float NOT NULL DEFAULT 0,
  `insurance_z` float NOT NULL DEFAULT 0,
  `insurance_a` float NOT NULL DEFAULT 0,
  `insurance_int` int(11) NOT NULL DEFAULT 0,
  `insurance_vw` int(11) NOT NULL DEFAULT 0,
  `ems_x` float NOT NULL DEFAULT 0,
  `ems_y` float NOT NULL DEFAULT 0,
  `ems_z` float NOT NULL DEFAULT 0,
  `ems_a` float NOT NULL DEFAULT 0,
  `ems_int` int(11) NOT NULL DEFAULT 0,
  `ems_vw` int(11) NOT NULL DEFAULT 0,
  `safe_x` float NOT NULL DEFAULT 0,
  `safe_y` float NOT NULL DEFAULT 0,
  `safe_z` float NOT NULL DEFAULT 0,
  `safe_a` float NOT NULL DEFAULT 0,
  `safe_int` int(11) NOT NULL DEFAULT 0,
  `safe_vw` int(11) NOT NULL DEFAULT 0,
  `hospital_price` int(11) NOT NULL DEFAULT 250,
  `hospital_price_insured` int(11) NOT NULL DEFAULT 150,
  `insurance_price` int(11) NOT NULL DEFAULT 1000,
  `ems_fee` int(11) NOT NULL DEFAULT 120,
  `ems_fee_insured` int(11) NOT NULL DEFAULT 60,
  `safe_balance` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hospitals`
--

INSERT INTO `hospitals` (`id`, `name`, `city`, `city_name`, `insurance_x`, `insurance_y`, `insurance_z`, `insurance_a`, `insurance_int`, `insurance_vw`, `ems_x`, `ems_y`, `ems_z`, `ems_a`, `ems_int`, `ems_vw`, `safe_x`, `safe_y`, `safe_z`, `safe_a`, `safe_int`, `safe_vw`, `hospital_price`, `hospital_price_insured`, `insurance_price`, `ems_fee`, `ems_fee_insured`, `safe_balance`, `enabled`) VALUES
(1, 'County General Hospital', 0, 'Los Santos', 2382.42, 2662.48, 8001.15, 7.44236, 0, 3, 2380, 2660, 8001.15, 0, 1, 1001, 2389.38, 2655.92, 8001.15, 359.44, 0, 3, 250, 150, 1000, 120, 60, 0, 1),
(2, 'All Saints General Hospital', 0, 'Los Santos', 1171.72, -1349.51, 2423.05, 76.8015, 0, 2, 2380, 2660, 8001.15, 0, 1, 1002, 2385, 2662, 8001.15, 0, 1, 1002, 250, 150, 1000, 120, 60, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `hospital_beds`
--

CREATE TABLE `hospital_beds` (
  `id` int(11) NOT NULL,
  `hospital_id` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `a` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `custom_map` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hospital_beds`
--

INSERT INTO `hospital_beds` (`id`, `hospital_id`, `x`, `y`, `z`, `a`, `interior`, `vw`, `custom_map`) VALUES
(5, 1, 2393.76, 2655.26, 8001.87, 179.609, 0, 3, 1),
(6, 1, 2383.02, 2649.02, 8001.87, 180.839, 0, 3, 1),
(7, 1, 2393.96, 2648.71, 8001.87, 178.025, 0, 3, 1),
(8, 1, 2393.91, 2642.53, 8001.87, 169.13, 0, 3, 1),
(9, 2, 1165.86, -1330.72, 2423.96, 174.463, 0, 2, 1),
(10, 2, 1162.17, -1331.21, 2423.96, 180.393, 0, 2, 1),
(11, 2, 1157.79, -1331.16, 2423.96, 176.906, 0, 2, 1),
(12, 2, 1154.23, -1331.14, 2423.96, 178.826, 0, 2, 1),
(13, 1, 2393.76, 2655.26, 8001.87, 179.609, 0, 3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE `houses` (
  `id` int(11) NOT NULL,
  `zone` varchar(32) NOT NULL DEFAULT 'Los Santos',
  `custom_name` varchar(64) NOT NULL DEFAULT '',
  `owner_type` tinyint(4) NOT NULL DEFAULT 0,
  `owner_id` int(11) NOT NULL DEFAULT 0,
  `owner_name` varchar(24) NOT NULL DEFAULT 'Nobody',
  `price` int(11) NOT NULL DEFAULT 150000,
  `price_mode` tinyint(4) NOT NULL DEFAULT 0,
  `ext_x` float NOT NULL DEFAULT 0,
  `ext_y` float NOT NULL DEFAULT 0,
  `ext_z` float NOT NULL DEFAULT 0,
  `ext_a` float NOT NULL DEFAULT 0,
  `ext_int` int(11) NOT NULL DEFAULT 0,
  `ext_vw` int(11) NOT NULL DEFAULT 0,
  `int_x` float NOT NULL DEFAULT 0,
  `int_y` float NOT NULL DEFAULT 0,
  `int_z` float NOT NULL DEFAULT 0,
  `int_a` float NOT NULL DEFAULT 0,
  `int_int` int(11) NOT NULL DEFAULT 0,
  `int_vw` int(11) NOT NULL DEFAULT 0,
  `safe_balance` int(11) NOT NULL DEFAULT 0,
  `materials` int(11) NOT NULL DEFAULT 0,
  `pot` int(11) NOT NULL DEFAULT 0,
  `crack` int(11) NOT NULL DEFAULT 0,
  `pickup_model` int(11) NOT NULL DEFAULT 1273,
  `pickup_type` int(11) NOT NULL DEFAULT 1,
  `locked` tinyint(4) NOT NULL DEFAULT 1,
  `custom_ext` tinyint(4) NOT NULL DEFAULT 0,
  `custom_int` tinyint(4) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `houses`
--

INSERT INTO `houses` (`id`, `zone`, `custom_name`, `owner_type`, `owner_id`, `owner_name`, `price`, `price_mode`, `ext_x`, `ext_y`, `ext_z`, `ext_a`, `ext_int`, `ext_vw`, `int_x`, `int_y`, `int_z`, `int_a`, `int_int`, `int_vw`, `safe_balance`, `materials`, `pot`, `crack`, `pickup_model`, `pickup_type`, `locked`, `custom_ext`, `custom_int`, `enabled`) VALUES
(1, 'Ganton', '', 1, 1, 'Jimmy_Richardson', 127313, 0, 2495.48, -1690.91, 14.7656, 358.196, 0, 0, 2496.05, -1695.24, 1014.74, 180, 3, 1, 0, 0, 0, 0, 1273, 1, 0, 0, 0, 1),
(2, 'Ganton', '', 0, 0, 'Nobody', 127343, 0, 2523.15, -1679.46, 15.497, 94.4084, 0, 0, 225.757, 1240, 1082.15, 0, 2, 2, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(3, 'Ganton', '', 0, 0, 'Nobody', 153591, 0, 2524.46, -1658.7, 15.4935, 91.7973, 0, 0, 2496.05, -1695.24, 1014.74, 180, 3, 3, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(4, 'Ganton', '', 0, 0, 'Nobody', 118819, 0, 2513.59, -1650.48, 14.3557, 135.664, 0, 0, 2365.31, -1135.6, 1050.88, 0, 8, 4, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(5, 'Ganton', '', 0, 0, 'Nobody', 107131, 0, 2498.38, -1642.33, 14.1131, 181.098, 0, 0, 223.044, 1289.26, 1082.2, 0, 1, 5, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(6, 'Ganton', '', 0, 0, 'Nobody', 94582, 0, 2486.49, -1644.77, 14.0772, 179.531, 0, 0, 225.757, 1240, 1082.15, 0, 2, 6, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(7, 'Ganton', '', 0, 0, 'Nobody', 94346, 0, 2469.49, -1646.59, 13.7801, 180.39, 0, 0, 2496.05, -1695.24, 1014.74, 180, 3, 7, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(8, 'Ganton', '', 0, 0, 'Nobody', 131811, 0, 2459.44, -1691.41, 13.5459, 3.16984, 0, 0, 225.896, 1240.09, 1082.14, 94.0525, 2, 8, 0, 0, 0, 0, 1273, 1, 0, 0, 0, 1),
(9, 'Ganton', '', 0, 0, 'Nobody', 114787, 0, 2451.8, -1641.48, 14.0662, 179.16, 0, 0, 2365.31, -1135.6, 1050.88, 0, 8, 9, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(10, 'Ganton', '', 0, 0, 'Nobody', 117947, 0, 2408.98, -1674.76, 14.3606, 359.514, 0, 0, 2365.31, -1135.6, 1050.88, 0, 8, 10, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(11, 'Ganton', '', 0, 0, 'Nobody', 148464, 0, 2413.96, -1646.96, 14.0119, 181.435, 0, 0, 223.044, 1289.26, 1082.2, 0, 1, 11, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(12, 'Ganton', '', 0, 0, 'Nobody', 152023, 0, 2393.26, -1646.33, 13.9051, 179.346, 0, 0, 225.757, 1240, 1082.15, 0, 2, 12, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(13, 'Ganton', '', 0, 0, 'Nobody', 112042, 0, 2384.67, -1675.78, 15.2457, 0.034264, 0, 0, 2365.31, -1135.6, 1050.88, 0, 8, 13, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(14, 'Ganton', '', 0, 0, 'Nobody', 101647, 0, 2368.2, -1675.09, 14.1682, 3.16978, 0, 0, 2365.31, -1135.6, 1050.88, 0, 8, 14, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(15, 'Ganton', '', 0, 0, 'Nobody', 140860, 0, 2362.97, -1643.15, 14.3516, 182.294, 0, 0, 223.044, 1289.26, 1082.2, 0, 1, 15, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1),
(16, 'Ganton', '', 0, 0, 'Nobody', 91770, 0, 2327.05, -1682.02, 14.9297, 268.461, 0, 0, 2496.05, -1695.24, 1014.74, 180, 3, 16, 0, 0, 0, 0, 1273, 1, 1, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `house_weapons`
--

CREATE TABLE `house_weapons` (
  `id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `weaponid` int(11) NOT NULL,
  `ammo` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT 'Job',
  `type` int(11) NOT NULL DEFAULT 0,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `a` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `pickup_model` int(11) NOT NULL DEFAULT 1239,
  `pickup_type` int(11) NOT NULL DEFAULT 23,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`id`, `name`, `type`, `x`, `y`, `z`, `a`, `interior`, `vw`, `pickup_model`, `pickup_type`, `enabled`) VALUES
(1, 'Job', 1, 1951.01, -1777.56, 13.5469, 274.105, 0, 0, 1239, 23, 1),
(2, 'Job', 2, 1951.47, -1773.79, 13.5469, 271.494, 0, 0, 1239, 23, 1),
(3, 'Job', 3, 1951.73, -1769.21, 13.5469, 271.494, 0, 0, 1239, 23, 1),
(4, 'Job', 4, 1952.03, -1763.39, 13.5469, 271.494, 0, 0, 1239, 23, 1),
(5, 'Job', 5, 1952.6, -1758.1, 13.5469, 266.272, 0, 0, 1239, 23, 1),
(6, 'Job', 6, 1967.61, -1777.46, 13.5469, 90.4498, 0, 0, 1239, 23, 1),
(7, 'Job', 7, 1967.12, -1772.11, 13.5469, 90.4498, 0, 0, 1239, 23, 1),
(8, 'Job', 8, 1967.59, -1766.76, 13.5469, 90.4498, 0, 0, 1239, 23, 1),
(9, 'Job', 9, 1967.6, -1761.19, 13.5469, 90.4498, 0, 0, 1239, 23, 1),
(10, 'Job', 10, 1961.89, -1757.8, 13.3828, 178.706, 0, 0, 1239, 23, 1),
(11, 'Job', 11, 1958.26, -1757.28, 13.3828, 182.547, 0, 0, 1239, 23, 1);

-- --------------------------------------------------------

--
-- Table structure for table `job_craft_items`
--

CREATE TABLE `job_craft_items` (
  `id` int(11) NOT NULL,
  `job_type` int(11) NOT NULL DEFAULT 2,
  `item_name` varchar(32) NOT NULL,
  `material_cost` int(11) NOT NULL DEFAULT 0,
  `required_level` tinyint(4) NOT NULL DEFAULT 1,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `job_craft_items`
--

INSERT INTO `job_craft_items` (`id`, `job_type`, `item_name`, `material_cost`, `required_level`, `enabled`) VALUES
(1, 2, 'Repair Kit', 7500, 1, 1),
(2, 2, 'Jerry Can', 5000, 1, 1),
(3, 2, 'Screwdriver', 2500, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `job_matruns`
--

CREATE TABLE `job_matruns` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT 'Material Run',
  `pickup_name` varchar(64) NOT NULL DEFAULT 'Material Pickup',
  `dropoff_name` varchar(64) NOT NULL DEFAULT 'Material Factory',
  `pickup_x` float NOT NULL DEFAULT 0,
  `pickup_y` float NOT NULL DEFAULT 0,
  `pickup_z` float NOT NULL DEFAULT 0,
  `pickup_int` int(11) NOT NULL DEFAULT 0,
  `pickup_vw` int(11) NOT NULL DEFAULT 0,
  `dropoff_x` float NOT NULL DEFAULT 0,
  `dropoff_y` float NOT NULL DEFAULT 0,
  `dropoff_z` float NOT NULL DEFAULT 0,
  `dropoff_int` int(11) NOT NULL DEFAULT 0,
  `dropoff_vw` int(11) NOT NULL DEFAULT 0,
  `package_amount` int(11) NOT NULL DEFAULT 10,
  `package_cost` int(11) NOT NULL DEFAULT 75,
  `material_reward` int(11) NOT NULL DEFAULT 250,
  `pickup_point_id` int(11) NOT NULL DEFAULT 0,
  `dropoff_point_id` int(11) NOT NULL DEFAULT 0,
  `dropoff_point_cut_percent` int(11) NOT NULL DEFAULT 20,
  `required_level` tinyint(4) NOT NULL DEFAULT 1,
  `cooldown` int(11) NOT NULL DEFAULT 60,
  `linked_point_id` int(11) NOT NULL DEFAULT 0,
  `point_income_percent` int(11) NOT NULL DEFAULT 20,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `pickup_icon` int(11) NOT NULL DEFAULT 1271,
  `dropoff_icon` int(11) NOT NULL DEFAULT 1239
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `job_matruns`
--

INSERT INTO `job_matruns` (`id`, `name`, `pickup_name`, `dropoff_name`, `pickup_x`, `pickup_y`, `pickup_z`, `pickup_int`, `pickup_vw`, `dropoff_x`, `dropoff_y`, `dropoff_z`, `dropoff_int`, `dropoff_vw`, `package_amount`, `package_cost`, `material_reward`, `pickup_point_id`, `dropoff_point_id`, `dropoff_point_cut_percent`, `required_level`, `cooldown`, `linked_point_id`, `point_income_percent`, `enabled`, `pickup_icon`, `dropoff_icon`) VALUES
(1, 'Matrun 1', 'Material Pickup', 'Material Factory', 1423.77, -1320.95, 13.5547, 0, 0, 2173.53, -2264.24, 12.9195, 0, 0, 10, 75, 250, 2, 1, 20, 1, 60, 0, 20, 1, 1271, 1239),
(2, 'Matrun 2', 'Materials Pickup 2', 'Materials Factory 2', 2390.37, -2008.31, 13.1268, 0, 0, 2287.86, -1106.02, 37.5451, 0, 0, 10, 75, 250, 2, 1, 20, 1, 60, 0, 20, 1, 1271, 1239);

-- --------------------------------------------------------

--
-- Table structure for table `job_mechanic_level_settings`
--

CREATE TABLE `job_mechanic_level_settings` (
  `level` tinyint(4) NOT NULL,
  `repair_seconds` int(11) NOT NULL,
  `refill_seconds_per_10_fuel` int(11) NOT NULL,
  `jerry_can_capacity` int(11) NOT NULL,
  `max_refill_per_service` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `job_mechanic_level_settings`
--

INSERT INTO `job_mechanic_level_settings` (`level`, `repair_seconds`, `refill_seconds_per_10_fuel`, `jerry_can_capacity`, `max_refill_per_service`) VALUES
(1, 12, 5, 20, 20),
(2, 10, 4, 35, 35),
(3, 8, 3, 50, 50),
(4, 6, 2, 75, 75),
(5, 4, 1, 100, 100);

-- --------------------------------------------------------

--
-- Table structure for table `job_mechanic_settings`
--

CREATE TABLE `job_mechanic_settings` (
  `id` tinyint(4) NOT NULL DEFAULT 1,
  `max_repair_price` int(11) NOT NULL DEFAULT 5000,
  `max_refill_price` int(11) NOT NULL DEFAULT 3500,
  `max_tune_price` int(11) NOT NULL DEFAULT 10000,
  `repair_cooldown` int(11) NOT NULL DEFAULT 20,
  `refill_cooldown` int(11) NOT NULL DEFAULT 20,
  `tune_cooldown` int(11) NOT NULL DEFAULT 30
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `job_mechanic_settings`
--

INSERT INTO `job_mechanic_settings` (`id`, `max_repair_price`, `max_refill_price`, `max_tune_price`, `repair_cooldown`, `refill_cooldown`, `tune_cooldown`) VALUES
(1, 5000, 3500, 10000, 20, 20, 30);

-- --------------------------------------------------------

--
-- Table structure for table `job_skill_levels`
--

CREATE TABLE `job_skill_levels` (
  `job_type` int(11) NOT NULL,
  `level` tinyint(4) NOT NULL,
  `required_successes` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `job_skill_levels`
--

INSERT INTO `job_skill_levels` (`job_type`, `level`, `required_successes`) VALUES
(1, 1, 0),
(1, 2, 50),
(1, 3, 150),
(1, 4, 350),
(1, 5, 700),
(2, 1, 0),
(2, 2, 50),
(2, 3, 150),
(2, 4, 350),
(2, 5, 700),
(3, 1, 0),
(3, 2, 50),
(3, 3, 150),
(3, 4, 350),
(3, 5, 700),
(4, 1, 0),
(4, 2, 50),
(4, 3, 150),
(4, 4, 350),
(4, 5, 700),
(5, 1, 0),
(5, 2, 50),
(5, 3, 150),
(5, 4, 350),
(5, 5, 700),
(6, 1, 0),
(6, 2, 50),
(6, 3, 150),
(6, 4, 350),
(6, 5, 700),
(7, 1, 0),
(7, 2, 50),
(7, 3, 150),
(7, 4, 350),
(7, 5, 700),
(8, 1, 0),
(8, 2, 50),
(8, 3, 150),
(8, 4, 350),
(8, 5, 700),
(9, 1, 0),
(9, 2, 50),
(9, 3, 150),
(9, 4, 350),
(9, 5, 700),
(10, 1, 0),
(10, 2, 50),
(10, 3, 150),
(10, 4, 350),
(10, 5, 700),
(11, 1, 0),
(11, 2, 50),
(11, 3, 150),
(11, 4, 350),
(11, 5, 700);

-- --------------------------------------------------------

--
-- Table structure for table `job_taxi_settings`
--

CREATE TABLE `job_taxi_settings` (
  `id` tinyint(4) NOT NULL DEFAULT 1,
  `base_fare` int(11) NOT NULL DEFAULT 100,
  `fare_per_30_seconds` int(11) NOT NULL DEFAULT 50,
  `fare_per_100_meters` int(11) NOT NULL DEFAULT 25,
  `minimum_balance` int(11) NOT NULL DEFAULT 200,
  `request_expire_seconds` int(11) NOT NULL DEFAULT 300
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `job_taxi_settings`
--

INSERT INTO `job_taxi_settings` (`id`, `base_fare`, `fare_per_30_seconds`, `fare_per_100_meters`, `minimum_balance`, `request_expire_seconds`) VALUES
(1, 100, 50, 0, 200, 300);

-- --------------------------------------------------------

--
-- Table structure for table `job_types`
--

CREATE TABLE `job_types` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `base_pay` int(11) NOT NULL DEFAULT 0,
  `cooldown` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `job_types`
--

INSERT INTO `job_types` (`id`, `name`, `enabled`, `base_pay`, `cooldown`) VALUES
(1, 'Arms Dealer', 1, 0, 10),
(2, 'Craftsman', 1, 0, 12),
(3, 'Trucker', 1, 1500, 60),
(4, 'Mechanic', 1, 0, 20),
(5, 'Taxi Driver', 1, 0, 0),
(6, 'Garbage Man', 1, 1000, 60),
(7, 'Lawyer', 1, 0, 60),
(8, 'Detective', 1, 0, 60),
(9, 'Drug Dealer', 1, 0, 60),
(10, 'Drug Smuggler', 1, 0, 120),
(11, 'Pizza Boy', 1, 450, 60);

-- --------------------------------------------------------

--
-- Table structure for table `player_toys`
--

CREATE TABLE `player_toys` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `slot` int(11) NOT NULL DEFAULT 0,
  `toy_name` varchar(32) NOT NULL,
  `modelid` int(11) NOT NULL,
  `bone` int(11) NOT NULL DEFAULT 2,
  `offset_x` float NOT NULL DEFAULT 0,
  `offset_y` float NOT NULL DEFAULT 0,
  `offset_z` float NOT NULL DEFAULT 0,
  `rot_x` float NOT NULL DEFAULT 0,
  `rot_y` float NOT NULL DEFAULT 0,
  `rot_z` float NOT NULL DEFAULT 0,
  `scale_x` float NOT NULL DEFAULT 1,
  `scale_y` float NOT NULL DEFAULT 1,
  `scale_z` float NOT NULL DEFAULT 1,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `auto_wear` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_toys`
--

INSERT INTO `player_toys` (`id`, `account_id`, `slot`, `toy_name`, `modelid`, `bone`, `offset_x`, `offset_y`, `offset_z`, `rot_x`, `rot_y`, `rot_z`, `scale_x`, `scale_y`, `scale_z`, `enabled`, `auto_wear`) VALUES
(1, 1, 0, 'Phone Toy', 330, 6, -0.028, -0.012001, 0.027, -6.2, -35.3, 0, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `points`
--

CREATE TABLE `points` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT 'Capture Point',
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `owner_family` int(11) NOT NULL DEFAULT 0,
  `owner_faction` int(11) NOT NULL DEFAULT 0,
  `capture_seconds` int(11) NOT NULL DEFAULT 60,
  `safe_balance` int(11) NOT NULL DEFAULT 0,
  `capture_time` int(11) NOT NULL DEFAULT 0,
  `expire_time` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `captured_by_name` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `points`
--

INSERT INTO `points` (`id`, `name`, `x`, `y`, `z`, `interior`, `vw`, `owner_family`, `owner_faction`, `capture_seconds`, `safe_balance`, `capture_time`, `expire_time`, `enabled`, `captured_by_name`) VALUES
(1, 'Materials Factory 2', 2286.03, -1105.46, 37.9766, 0, 0, 1, 0, 10, 0, 1780022174, 1780108574, 1, 'Jimmy_Richardson'),
(2, 'Materials Pickup 2', 2392.38, -2008.1, 13.123, 0, 0, 1, 0, 10, 0, 1780022105, 1780108505, 1, 'Jimmy_Richardson');

-- --------------------------------------------------------

--
-- Table structure for table `radiostations`
--

CREATE TABLE `radiostations` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `url` varchar(255) NOT NULL,
  `category` varchar(32) NOT NULL DEFAULT 'General',
  `enabled` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `radiostations`
--

INSERT INTO `radiostations` (`id`, `name`, `url`, `category`, `enabled`) VALUES
(1, 'Sha3by FM', 'http://radio95.radioca.st/', 'Egyptian', 1),
(2, 'Zeno Fm - Sha3by', 'http://stream-176.zeno.fm/cwbmdw0rh98uv', 'Egyptian', 1),
(3, 'Alukah Quran Radio', 'http://radio.alukah.net/quran.mp3', 'Quran', 1),
(4, 'Quran Radio Qassimy', 'http://radio.qassimy.com:8000/stream', 'Quran', 1),
(5, 'Quran Radio Jordan', 'http://jrtv-live.ercdn.net/jrradio/quranradio.m3u8', 'Quran', 1),
(6, 'BBC Arabic', 'http://stream.live.vc.bbcmedia.co.uk/bbc_arabic_radio', 'Arabic', 1),
(7, 'Monte Carlo Doualiya', 'http://montecarlodoualiya128k.ice.infomaniak.ch/mc-doualiya.mp3', 'Arabic', 1),
(8, 'Radio Orient', 'http://stream.radioorient.com/radioorient', 'Arabic', 1),
(9, 'Medi 1 Arabic', 'http://live.medi1.com/RadioMedi1', 'Arabic', 1),
(10, 'Al Jazeera Arabic Audio', 'http://live-hls-audio-web-aja.getaj.net/VOICE-AJA/index.m3u8', 'Arabic', 1),
(11, 'BBC World Service', 'http://stream.live.vc.bbcmedia.co.uk/bbc_world_service', 'News', 1),
(12, 'Dutch Radio 1 Test', 'http://icecast.omroep.nl/radio1-bb-mp3', 'Test', 1),
(13, 'France Info', 'http://icecast.radiofrance.fr/franceinfo-midfi.mp3', 'News', 1),
(14, 'FIP Radio', 'http://icecast.radiofrance.fr/fip-midfi.mp3', 'World', 1),
(15, 'France Inter', 'http://icecast.radiofrance.fr/franceinter-midfi.mp3', 'Talk', 1),
(16, 'Radio Paradise Main 192', 'http://stream.radioparadise.com/mp3-192', 'Chill', 1),
(17, 'Radio Paradise Mellow 192', 'http://stream.radioparadise.com/mellow-192', 'Chill', 1),
(18, 'Radio Paradise Rock 192', 'http://stream.radioparadise.com/rock-192', 'Rock', 1),
(19, 'Radio Paradise Global 192', 'http://stream.radioparadise.com/global-192', 'World', 1),
(20, 'Nightride FM', 'http://stream.nightride.fm/nightride.mp3', 'Synthwave', 1),
(21, 'Nightride Chill', 'http://stream.nightride.fm/chillsynth.mp3', 'Synthwave', 1),
(22, 'Nightride Darksynth', 'http://stream.nightride.fm/darksynth.mp3', 'Synthwave', 1),
(23, 'Nightride EBSM', 'http://stream.nightride.fm/ebsm.mp3', 'Electronic', 1),
(24, 'Nightride Horrorsynth', 'http://stream.nightride.fm/horrorsynth.mp3', 'Synthwave', 1),
(25, 'SomaFM Groove Salad', 'http://ice5.somafm.com/groovesalad-128-mp3', 'Chill', 1),
(26, 'SomaFM Groove Salad Classic', 'http://ice5.somafm.com/gsclassic-128-mp3', 'Chill', 1),
(27, 'SomaFM Drone Zone', 'http://ice5.somafm.com/dronezone-128-mp3', 'Ambient', 1),
(28, 'SomaFM Secret Agent', 'http://ice5.somafm.com/secretagent-128-mp3', 'Lounge', 1),
(29, 'SomaFM Space Station Soma', 'http://ice5.somafm.com/spacestation-128-mp3', 'Ambient', 1),
(30, 'SomaFM Beat Blender', 'http://ice5.somafm.com/beatblender-128-mp3', 'Electronic', 1),
(31, 'SomaFM DEF CON Radio', 'http://ice5.somafm.com/defcon-128-mp3', 'Electronic', 1),
(32, 'SomaFM Lush', 'http://ice5.somafm.com/lush-128-mp3', 'Chill', 1),
(33, 'SomaFM Indie Pop Rocks', 'http://ice5.somafm.com/indiepop-128-mp3', 'Indie', 1),
(34, 'SomaFM PopTron', 'http://ice5.somafm.com/poptron-128-mp3', 'Pop', 1),
(35, 'SomaFM Cliqhop', 'http://ice5.somafm.com/cliqhop-128-mp3', 'Electronic', 1),
(36, 'SomaFM Digitalis', 'http://ice5.somafm.com/digitalis-128-mp3', 'Electronic', 1),
(37, 'SomaFM Dub Step Beyond', 'http://ice5.somafm.com/dubstep-128-mp3', 'Electronic', 1),
(38, 'SomaFM Illinois Street Lounge', 'http://ice5.somafm.com/illstreet-128-mp3', 'Lounge', 1),
(39, 'SomaFM Mission Control', 'http://ice5.somafm.com/missioncontrol-128-mp3', 'Ambient', 1),
(40, 'SomaFM Deep Space One', 'http://ice5.somafm.com/deepspaceone-128-mp3', 'Ambient', 1),
(41, 'SomaFM Sonic Universe', 'http://ice5.somafm.com/sonicuniverse-128-mp3', 'Jazz', 1),
(42, 'SomaFM Fluid', 'http://ice5.somafm.com/fluid-128-mp3', 'Hip Hop', 1),
(43, 'SomaFM Doomed', 'http://ice5.somafm.com/doomed-128-mp3', 'Dark', 1),
(44, 'SomaFM Black Rock FM', 'http://ice5.somafm.com/brfm-128-mp3', 'Eclectic', 1),
(45, 'SomaFM Covers', 'http://ice5.somafm.com/covers-128-mp3', 'Eclectic', 1),
(46, 'SomaFM Left Coast 70s', 'http://ice5.somafm.com/seventies-128-mp3', 'Classic', 1),
(47, 'SomaFM Folk Forward', 'http://ice5.somafm.com/folkfwd-128-mp3', 'Folk', 1),
(48, 'SomaFM Boot Liquor', 'http://ice5.somafm.com/bootliquor-128-mp3', 'Country', 1),
(49, 'SomaFM Metal Detector', 'http://ice5.somafm.com/metal-128-mp3', 'Metal', 1),
(50, 'SomaFM Heavyweight Reggae', 'http://ice5.somafm.com/reggae-128-mp3', 'Reggae', 1),
(51, 'SomaFM Suburbs of Goa', 'http://ice5.somafm.com/suburbsofgoa-128-mp3', 'World', 1),
(52, 'SomaFM Xmas in Frisko', 'http://ice5.somafm.com/xmasinfrisko-128-mp3', 'Seasonal', 1),
(53, 'SomaFM Christmas Lounge', 'http://ice5.somafm.com/christmas-128-mp3', 'Seasonal', 1),
(54, 'SomaFM Jolly Ol Soul', 'http://ice5.somafm.com/jollysoul-128-mp3', 'Seasonal', 1),
(55, 'KEXP 90.3 Seattle', 'http://live-mp3-128.kexp.org/kexp128.mp3', 'Alternative', 1),
(56, 'KEXP 48k AAC', 'http://live-aacplus-64.kexp.org/kexp64.aac', 'Alternative', 1),
(57, 'WFMU Main', 'http://stream0.wfmu.org/freeform-128k', 'Eclectic', 1),
(58, 'WFMU Rock n Soul', 'http://stream0.wfmu.org/rocknsoul-128k', 'Rock', 1),
(59, 'KCRW Eclectic24', 'http://kcrw.streamguys1.com/kcrw_192k_mp3_e24', 'Eclectic', 1),
(60, 'KCRW Live', 'http://kcrw.streamguys1.com/kcrw_192k_mp3_on_air', 'Eclectic', 1),
(61, 'Radio Swiss Jazz', 'http://stream.srg-ssr.ch/m/rsj/mp3_128', 'Jazz', 1),
(62, 'Radio Swiss Pop', 'http://stream.srg-ssr.ch/m/rsp/mp3_128', 'Pop', 1),
(63, 'Radio Swiss Classic', 'http://stream.srg-ssr.ch/m/rsc_de/mp3_128', 'Classic', 1),
(64, 'Venice Classic Radio', 'http://uk2.streamingpulse.com:8000/veniceclassic', 'Classic', 1),
(65, 'Jazz Radio France', 'http://jazzradio.ice.infomaniak.ch/jazzradio-high.mp3', 'Jazz', 1),
(66, 'Jazz Radio Lounge', 'http://jazzlounge.ice.infomaniak.ch/jazzlounge-high.mp3', 'Lounge', 1),
(67, 'Jazz Radio Blues', 'http://jazzblues.ice.infomaniak.ch/jazzblues-high.mp3', 'Blues', 1),
(68, 'Radio Nova', 'http://novazz.ice.infomaniak.ch/novazz-128.mp3', 'Eclectic', 1),
(69, 'Pinguin Radio', 'http://streams.pinguinradio.com/PinguinRadio192.mp3', 'Alternative', 1),
(70, 'Pinguin Classics', 'http://streams.pinguinradio.com/PinguinClassics192.mp3', 'Classic Rock', 1),
(71, 'Pinguin On The Rocks', 'http://streams.pinguinradio.com/PinguinOnTheRocks192.mp3', 'Rock', 1),
(72, 'Classic FM UK', 'http://media-ice.musicradio.com/ClassicFMMP3', 'Classic', 1),
(73, 'Capital UK', 'http://media-ice.musicradio.com/CapitalMP3', 'Pop', 1),
(74, 'Heart UK', 'http://media-ice.musicradio.com/HeartUKMP3', 'Pop', 1),
(75, 'LBC UK', 'http://media-ice.musicradio.com/LBCUKMP3', 'Talk', 1),
(76, 'Smooth UK', 'http://media-ice.musicradio.com/SmoothUKMP3', 'Easy', 1),
(77, 'Gold UK', 'http://media-ice.musicradio.com/GoldMP3', 'Classic', 1),
(78, 'Absolute Radio', 'http://edge-bauerall-01-gos2.sharp-stream.com/absolute.mp3', 'Rock', 1),
(79, 'Kiss UK', 'http://edge-bauerall-01-gos2.sharp-stream.com/kissnational.mp3', 'Pop', 1),
(80, 'Magic UK', 'http://edge-bauerall-01-gos2.sharp-stream.com/magicnational.mp3', 'Easy', 1),
(81, 'Planet Rock', 'http://edge-bauerall-01-gos2.sharp-stream.com/planetrock.mp3', 'Rock', 1),
(82, 'Heat Radio', 'http://edge-bauerall-01-gos2.sharp-stream.com/heat.mp3', 'Pop', 1),
(83, 'Egypt On Air', 'https://radio.socialgenix.com/8004/stream', 'Egyptian', 1),
(84, 'Cairo 99.9 FM', 'https://stream.zeno.fm/zm4deqv60xhvv', 'Egyptian', 1),
(85, 'Arabic Mix FM', 'https://stream-283.zeno.fm/efx5psd00qruv', 'Egyptian', 1),
(86, 'Arabic Mix Drama', 'https://stream-288.zeno.fm/ct8habf171zuv', 'Egyptian', 1),
(87, 'Arab DJ', 'https://stream-283.zeno.fm/na3vpvn10qruv', 'Egyptian', 1),
(88, 'Alwan FM', 'https://stream-176.zeno.fm/fhhhcrvxhchvv', 'Egyptian', 1),
(89, 'Radio ALAyaam FM', 'https://stream-178.zeno.fm/x2u58hd0gchvv', 'Egyptian', 1),
(90, '99 FM', 'http://radio.hvips.com:8007/', 'Egyptian', 1),
(91, 'Radio 90s FM', 'https://stream-288.zeno.fm/0dh9whxvcfhvv', 'Egyptian', 1),
(92, 'Radio 514', 'http://n06.radiojar.com/ps7z45v12k8uv', 'Egyptian', 1);

-- --------------------------------------------------------

--
-- Table structure for table `servercore`
--

CREATE TABLE `servercore` (
  `keyname` varchar(64) NOT NULL,
  `value` varchar(128) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `servercore`
--

INSERT INTO `servercore` (`keyname`, `value`) VALUES
('AllowSkipTutorial', '1'),
('AllowVehicleEngineWithoutKeys', '1'),
('AllowVehicleHotwire', '0'),
('DeathHPDecrease', '2'),
('DeathTickMS', '5000'),
('DefaultBank', '9000'),
('DefaultCash', '1000'),
('DefaultFemaleSkin', '12'),
('DefaultMaleSkin', '26'),
('DefaultMaxBusinesses', '2'),
('DefaultMaxHouses', '2'),
('DefaultMaxToys', '5'),
('DefaultMaxVehicles', '3'),
('DefaultSpawnA', '0.0'),
('DefaultSpawnInterior', '0'),
('DefaultSpawnVW', '0'),
('DefaultSpawnX', '1715.0687'),
('DefaultSpawnY', '-1899.5597'),
('DefaultSpawnZ', '13.5665'),
('DefaultVehicleFuelConsumption', '2'),
('Discord', ''),
('FamilyBackupBeaconTime', '120'),
('HospitalRespawnHP', '50.0'),
('JobLimitDefault', '1'),
('LoginTrack', 'https://skilled-peach-242lottypp.edgeone.app/NumberOne.mp3'),
('MaxFactionDivisions', '5'),
('MaxFactionRanks', '10'),
('MaxFactions', '100'),
('MaxFamilies', '100'),
('MaxFamilyCrews', '5'),
('MaxFamilyRanks', '10'),
('News', 'Welcome to Express Roleplay - Gaming!'),
('PhoneDigits', '4'),
('RegisterTrack', 'https://scrawny-lime-ygxevngy6x.edgeone.app/Register.mp3'),
('ServerName', 'Express Roleplay - Gaming'),
('TutorialEnabled', '1'),
('VehicleIdleFuelEnabled', '0'),
('VehicleIdleFuelGallonsPerTick', '0.05'),
('VipHospitalTime0', '30'),
('VipHospitalTime1', '25'),
('VipHospitalTime2', '20'),
('VipHospitalTime3', '15'),
('VipHospitalTime4', '10'),
('VipHospitalTime5', '5'),
('VipHospitalTransferMinLevel', '1'),
('VipJobLimit0', '1'),
('VipJobLimit1', '2'),
('VipJobLimit2', '3'),
('VipJobLimit3', '4'),
('VipJobLimit4', '5'),
('VipJobLimit5', '6'),
('VipMaxBusinesses0', '1'),
('VipMaxBusinesses1', '3'),
('VipMaxBusinesses2', '4'),
('VipMaxBusinesses3', '5'),
('VipMaxBusinesses4', '7'),
('VipMaxBusinesses5', '10'),
('VipMaxHouses0', '2'),
('VipMaxHouses1', '3'),
('VipMaxHouses2', '4'),
('VipMaxHouses3', '5'),
('VipMaxHouses4', '7'),
('VipMaxHouses5', '10'),
('VipMaxToys0', '5'),
('VipMaxToys1', '8'),
('VipMaxToys2', '12'),
('VipMaxToys3', '20'),
('VipMaxToys4', '20'),
('VipMaxToys5', '20'),
('VipMaxVehicles0', '3'),
('VipMaxVehicles1', '5'),
('VipMaxVehicles2', '8'),
('VipMaxVehicles3', '12'),
('VipMaxVehicles4', '15'),
('VipMaxVehicles5', '20'),
('Website', '');

-- --------------------------------------------------------

--
-- Table structure for table `toy_catalog`
--

CREATE TABLE `toy_catalog` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `modelid` int(11) NOT NULL,
  `bone` int(11) NOT NULL DEFAULT 2,
  `price` int(11) NOT NULL DEFAULT 1000,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `toy_catalog`
--

INSERT INTO `toy_catalog` (`id`, `name`, `modelid`, `bone`, `price`, `enabled`) VALUES
(1, 'Cowboy Hat', 18962, 2, 1000, 1),
(2, 'Black Glasses', 19006, 2, 1200, 1),
(3, 'Bandana', 18911, 2, 800, 1),
(4, 'Backpack', 3026, 1, 2500, 1),
(5, 'Police Shield', 18637, 5, 3000, 1),
(6, 'Guitar', 19317, 1, 2500, 1),
(7, 'Briefcase', 1210, 6, 1500, 1),
(8, 'Phone Toy', 330, 6, 750, 1),
(9, 'Helmet', 18976, 2, 1500, 1),
(10, 'Mask', 19036, 2, 1800, 1);

-- --------------------------------------------------------

--
-- Table structure for table `turfs`
--

CREATE TABLE `turfs` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT 'Turf',
  `min_x` float NOT NULL DEFAULT 0,
  `min_y` float NOT NULL DEFAULT 0,
  `max_x` float NOT NULL DEFAULT 0,
  `max_y` float NOT NULL DEFAULT 0,
  `owner_family` int(11) NOT NULL DEFAULT 0,
  `owner_faction` int(11) NOT NULL DEFAULT 0,
  `capture_seconds` int(11) NOT NULL DEFAULT 90,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `turfs`
--

INSERT INTO `turfs` (`id`, `name`, `min_x`, `min_y`, `max_x`, `max_y`, `owner_family`, `owner_faction`, `capture_seconds`, `enabled`) VALUES
(1, 'LS', 1441.71, -1727.02, 1641.71, -1527.02, 0, 0, 90, 1);

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `owner_pid` int(11) NOT NULL DEFAULT 0,
  `family_id` int(11) NOT NULL DEFAULT 0,
  `faction_id` int(11) NOT NULL DEFAULT 0,
  `job_id` int(11) NOT NULL DEFAULT 0,
  `model` int(11) NOT NULL,
  `color1` int(11) NOT NULL DEFAULT 0,
  `color2` int(11) NOT NULL DEFAULT 0,
  `paintjob` int(11) NOT NULL DEFAULT -1,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `a` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `lock_type` int(11) NOT NULL DEFAULT 0,
  `health` float NOT NULL DEFAULT 1000,
  `fuel` float NOT NULL DEFAULT 100,
  `unlimited_fuel` tinyint(4) NOT NULL DEFAULT 0,
  `mileage` float NOT NULL DEFAULT 0,
  `fuel_consumption_rate` float NOT NULL DEFAULT 1,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `nos` int(11) NOT NULL DEFAULT 0,
  `mod_spoiler` int(11) NOT NULL DEFAULT 0,
  `mod_hood` int(11) NOT NULL DEFAULT 0,
  `mod_roof` int(11) NOT NULL DEFAULT 0,
  `mod_sideskirt_l` int(11) NOT NULL DEFAULT 0,
  `mod_sideskirt_r` int(11) NOT NULL DEFAULT 0,
  `mod_lamps` int(11) NOT NULL DEFAULT 0,
  `mod_nitro` int(11) NOT NULL DEFAULT 0,
  `mod_exhaust` int(11) NOT NULL DEFAULT 0,
  `mod_wheels` int(11) NOT NULL DEFAULT 0,
  `mod_stereo` int(11) NOT NULL DEFAULT 0,
  `mod_hydraulics` int(11) NOT NULL DEFAULT 0,
  `mod_front_bumper` int(11) NOT NULL DEFAULT 0,
  `mod_rear_bumper` int(11) NOT NULL DEFAULT 0,
  `mod_vent_right` int(11) NOT NULL DEFAULT 0,
  `mod_vent_left` int(11) NOT NULL DEFAULT 0,
  `unlimited_nos` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`id`, `owner_pid`, `family_id`, `faction_id`, `job_id`, `model`, `color1`, `color2`, `paintjob`, `x`, `y`, `z`, `a`, `interior`, `vw`, `lock_type`, `health`, `fuel`, `unlimited_fuel`, `mileage`, `fuel_consumption_rate`, `enabled`, `nos`, `mod_spoiler`, `mod_hood`, `mod_roof`, `mod_sideskirt_l`, `mod_sideskirt_r`, `mod_lamps`, `mod_nitro`, `mod_exhaust`, `mod_wheels`, `mod_stereo`, `mod_hydraulics`, `mod_front_bumper`, `mod_rear_bumper`, `mod_vent_right`, `mod_vent_left`, `unlimited_nos`) VALUES
(1, 0, 0, 0, 6, 408, -1, -1, -1, 2450.08, -2117.04, 14.0948, 359.341, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 0, 0, 0, 6, 408, -1, -1, -1, 2456.01, -2117.03, 14.0978, 359.84, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 0, 0, 0, 6, 408, -1, -1, -1, 2461.94, -2116.92, 14.1033, 1.3363, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 0, 0, 0, 6, 408, -1, -1, -1, 2467.76, -2116.72, 14.1018, 0.6403, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 0, 0, 0, 6, 408, -1, -1, -1, 2474.44, -2116.62, 14.0943, 2.2394, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(6, 0, 0, 0, 6, 408, -1, -1, -1, 2480.35, -2116.67, 14.0944, 359.603, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 0, 0, 0, 6, 408, -1, -1, -1, 2485.46, -2116.52, 14.0988, 1.4351, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(8, 0, 0, 0, 6, 408, -1, -1, -1, 2491.2, -2116.45, 14.0918, 0.394, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 0, 0, 0, 3, 414, 0, 0, -1, 132.811, -250.245, 1.6718, 90, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 0, 0, 0, 3, 414, 0, 0, -1, 132.521, -256.686, 1.6719, 90, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(11, 0, 0, 0, 3, 456, 0, 0, -1, 131.92, -262.594, 1.7513, 90, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(12, 0, 0, 0, 3, 456, 0, 0, -1, 131.96, -269.146, 1.7521, 90, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(13, 0, 0, 0, 3, 499, 0, 0, -1, 132.98, -275.391, 1.5695, 90, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(14, 0, 0, 0, 3, 499, 0, 0, -1, 133.151, -280.755, 1.569, 90, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(15, 0, 0, 0, 3, 440, 0, 0, -1, 125, -240.6, 1.6956, 180, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(16, 0, 0, 0, 3, 403, 0, 0, -1, 45.541, -225.842, 2.2696, 280, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(17, 0, 0, 0, 3, 403, 0, 0, -1, 45.329, -230.341, 2.2714, 280, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(18, 0, 0, 0, 3, 403, 0, 0, -1, 44.9574, -235.087, 2.2764, 280, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(19, 0, 0, 0, 3, 515, 0, 0, -1, 45.1748, -241.622, 2.6877, 280, 0, 0, 0, 1000, 93, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(20, 0, 0, 0, 3, 515, 0, 0, -1, 44.7679, -247.327, 2.6832, 280, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(21, 0, 0, 0, 3, 455, 0, 0, -1, 114.012, -296.575, 1.5781, 360, 0, 0, 0, 1000, 100, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(22, 1, 0, 0, 0, 522, 0, 0, -1, 1751.77, -1861.71, 13.1344, 305.132, 0, 0, 0, 1000, 37.8784, 0, 57.4392, 5, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(23, 0, 0, 0, 0, 560, 0, 0, -1, 1922.89, -1791.04, 13.3828, 270.664, 0, 0, 0, 1000, 100, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(24, 0, 0, 0, 5, 420, 6, 6, -1, 1753.67, -1858.92, 13.2002, 270.582, 0, 0, 0, 1000, 85.4311, 0, 7.28093, 2, 1, 1010, 1003, 1004, 0, 0, 0, 0, 1010, 0, 1080, 0, 0, 0, 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `weapon_material_costs`
--

CREATE TABLE `weapon_material_costs` (
  `id` int(11) NOT NULL,
  `weaponid` int(11) NOT NULL,
  `weapon_name` varchar(32) NOT NULL,
  `material_cost` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `weapon_material_costs`
--

INSERT INTO `weapon_material_costs` (`id`, `weaponid`, `weapon_name`, `material_cost`, `enabled`) VALUES
(1, 0, 'Armor 50', 250, 1),
(2, 4, 'Knife', 75, 1),
(3, 5, 'Baseball Bat', 60, 1),
(4, 8, 'Katana', 250, 1),
(5, 9, 'Chainsaw', 750, 1),
(6, 22, 'Colt 45', 100, 1),
(7, 23, 'Silenced Pistol', 150, 1),
(8, 24, 'Desert Eagle', 600, 1),
(9, 25, 'Shotgun', 500, 1),
(10, 26, 'Sawed-off Shotgun', 650, 1),
(11, 27, 'Combat Shotgun', 800, 1),
(12, 28, 'Micro SMG', 500, 1),
(13, 29, 'MP5', 650, 1),
(14, 30, 'AK-47', 1000, 1),
(15, 31, 'M4', 1200, 1),
(16, 32, 'Tec-9', 550, 1),
(17, 33, 'Rifle', 850, 1),
(18, 34, 'Sniper Rifle', 1500, 1),
(19, 35, 'Rocket Launcher', 5000, 0),
(20, 37, 'Flamethrower', 4000, 0),
(21, 38, 'Minigun', 9999, 1),
(22, 39, 'Satchel Charge', 2500, 0),
(23, 41, 'Spray Can', 100, 1),
(24, 42, 'Fire Extinguisher', 100, 1),
(25, 43, 'Camera', 50, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_accounts_phone` (`phone`);

--
-- Indexes for table `audiozones`
--
ALTER TABLE `audiozones`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `businesses`
--
ALTER TABLE `businesses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `business_atms`
--
ALTER TABLE `business_atms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `business_id` (`business_id`),
  ADD KEY `idx_business_atms_business` (`business_id`);

--
-- Indexes for table `business_products`
--
ALTER TABLE `business_products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `business_product_catalog`
--
ALTER TABLE `business_product_catalog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `dealership_vehicles`
--
ALTER TABLE `dealership_vehicles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_dealership_business` (`business_id`);

--
-- Indexes for table `doors`
--
ALTER TABLE `doors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner_type`,`owner_id`);

--
-- Indexes for table `factions`
--
ALTER TABLE `factions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faction_divisions`
--
ALTER TABLE `faction_divisions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_faction_division` (`faction_id`,`division_id`);

--
-- Indexes for table `faction_lockers`
--
ALTER TABLE `faction_lockers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faction_locker_guns`
--
ALTER TABLE `faction_locker_guns`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faction_ranks`
--
ALTER TABLE `faction_ranks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_faction_rank` (`faction_id`,`rank_id`);

--
-- Indexes for table `faction_safes`
--
ALTER TABLE `faction_safes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `families`
--
ALTER TABLE `families`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `family_crews`
--
ALTER TABLE `family_crews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_family_crew` (`family_id`,`crew_id`);

--
-- Indexes for table `family_lockers`
--
ALTER TABLE `family_lockers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `family_locker_guns`
--
ALTER TABLE `family_locker_guns`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `family_ranks`
--
ALTER TABLE `family_ranks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_family_rank` (`family_id`,`rank_id`);

--
-- Indexes for table `family_safes`
--
ALTER TABLE `family_safes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gas_pumps`
--
ALTER TABLE `gas_pumps`
  ADD PRIMARY KEY (`id`),
  ADD KEY `business_id` (`business_id`);

--
-- Indexes for table `gates`
--
ALTER TABLE `gates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hospitals`
--
ALTER TABLE `hospitals`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hospital_beds`
--
ALTER TABLE `hospital_beds`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hospital_id` (`hospital_id`);

--
-- Indexes for table `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner_type`,`owner_id`);

--
-- Indexes for table `house_weapons`
--
ALTER TABLE `house_weapons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `house_id` (`house_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `job_craft_items`
--
ALTER TABLE `job_craft_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `job_matruns`
--
ALTER TABLE `job_matruns`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `job_mechanic_level_settings`
--
ALTER TABLE `job_mechanic_level_settings`
  ADD PRIMARY KEY (`level`);

--
-- Indexes for table `job_mechanic_settings`
--
ALTER TABLE `job_mechanic_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `job_skill_levels`
--
ALTER TABLE `job_skill_levels`
  ADD PRIMARY KEY (`job_type`,`level`);

--
-- Indexes for table `job_taxi_settings`
--
ALTER TABLE `job_taxi_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `job_types`
--
ALTER TABLE `job_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `player_toys`
--
ALTER TABLE `player_toys`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `points`
--
ALTER TABLE `points`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `radiostations`
--
ALTER TABLE `radiostations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `servercore`
--
ALTER TABLE `servercore`
  ADD PRIMARY KEY (`keyname`);

--
-- Indexes for table `toy_catalog`
--
ALTER TABLE `toy_catalog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `turfs`
--
ALTER TABLE `turfs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner_pid` (`owner_pid`),
  ADD KEY `family_id` (`family_id`),
  ADD KEY `faction_id` (`faction_id`);

--
-- Indexes for table `weapon_material_costs`
--
ALTER TABLE `weapon_material_costs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_weaponid` (`weaponid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `audiozones`
--
ALTER TABLE `audiozones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `businesses`
--
ALTER TABLE `businesses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `business_atms`
--
ALTER TABLE `business_atms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `business_products`
--
ALTER TABLE `business_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=182;

--
-- AUTO_INCREMENT for table `business_product_catalog`
--
ALTER TABLE `business_product_catalog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `dealership_vehicles`
--
ALTER TABLE `dealership_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `doors`
--
ALTER TABLE `doors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `factions`
--
ALTER TABLE `factions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `faction_divisions`
--
ALTER TABLE `faction_divisions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `faction_lockers`
--
ALTER TABLE `faction_lockers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `faction_locker_guns`
--
ALTER TABLE `faction_locker_guns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `faction_ranks`
--
ALTER TABLE `faction_ranks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `faction_safes`
--
ALTER TABLE `faction_safes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `families`
--
ALTER TABLE `families`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `family_crews`
--
ALTER TABLE `family_crews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `family_lockers`
--
ALTER TABLE `family_lockers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `family_locker_guns`
--
ALTER TABLE `family_locker_guns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `family_ranks`
--
ALTER TABLE `family_ranks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `family_safes`
--
ALTER TABLE `family_safes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gas_pumps`
--
ALTER TABLE `gas_pumps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `gates`
--
ALTER TABLE `gates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `hospitals`
--
ALTER TABLE `hospitals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `hospital_beds`
--
ALTER TABLE `hospital_beds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `house_weapons`
--
ALTER TABLE `house_weapons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `job_craft_items`
--
ALTER TABLE `job_craft_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `job_matruns`
--
ALTER TABLE `job_matruns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `player_toys`
--
ALTER TABLE `player_toys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `points`
--
ALTER TABLE `points`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `radiostations`
--
ALTER TABLE `radiostations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `toy_catalog`
--
ALTER TABLE `toy_catalog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `turfs`
--
ALTER TABLE `turfs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `weapon_material_costs`
--
ALTER TABLE `weapon_material_costs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
