-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 12, 2026 at 10:49 PM
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
  `faction_division` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `username`, `password`, `tutorial`, `admin`, `vip`, `level`, `playing_hours`, `age`, `dob`, `country`, `gender`, `accent`, `skin`, `cash`, `bank`, `phone`, `phonebook`, `phone_off`, `has_radio`, `radio_freq`, `vehicle_lock`, `hosp_insurance`, `married_to`, `crimes`, `arrests`, `wanted_level`, `materials`, `pot`, `crack`, `rope`, `packages`, `seeds`, `sprunk`, `spraycans`, `health`, `armor`, `respect_points`, `warnings`, `hospital_time`, `tog_free_hospital`, `family_id`, `faction_id`, `family_rank`, `family_crew`, `business_id`, `spawn_x`, `spawn_y`, `spawn_z`, `spawn_a`, `spawn_int`, `spawn_vw`, `job0`, `job1`, `job2`, `job3`, `job4`, `job5`, `job6`, `job7`, `job8`, `job9`, `weapon0`, `weapon1`, `weapon2`, `weapon3`, `weapon4`, `weapon5`, `weapon6`, `weapon7`, `weapon8`, `weapon9`, `weapon10`, `weapon11`, `weapon12`, `fav_radio`, `faction_rank`, `faction_division`) VALUES
(1, 'Jimmy_Richardson', '7D73388F9B889B1E59642AEE80007658A8B3041BC6B5F52CFC5E88C84B04DFF67A74E05EB31280FF609177BB27C6093DF4D41EBFDF5BE8112220F85AE84D0CE4', 1, 99999, 0, 1, 0, 18, '01/01/2000', 'Egypt', 1, 1, 26, 700, 100000, 0, 0, 0, 0, 0, 0, 1, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 42, 0, 0, 0, 30, 0, 1, 0, 6, 0, 0, 2490.84, -1666.55, 13.3438, 175.399, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0),
(2, 'Mr_Richardson', '8937FB46BC7C1A44E1CFFDE9CBB854950F7AE8FF889CD854418BEDF70E3BECC2D36B5A4E95D809B4C0442FA78E56F5E08666743A97637B2D941D76E42C96A5CD', 1, 0, 0, 1, 0, 29, '09/30/1996', 'Unknown', 1, 1, 26, 18, 48, 85, 0, 0, 0, 0, 0, 1, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 30, 0, 0, 0, 0, 0, 0, 1715.07, -1899.56, 13.5665, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

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
(2, 'Arabic Mix FM', 'https://stream-283.zeno.fm/efx5psd00qruv', 2479.62, -1671.83, 12.8869, 150, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `businesses`
--

CREATE TABLE `businesses` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 1,
  `owner_id` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 250000,
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
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `businesses`
--

INSERT INTO `businesses` (`id`, `name`, `type`, `owner_id`, `price`, `materials`, `materials_capacity`, `safe_balance`, `ext_x`, `ext_y`, `ext_z`, `ext_a`, `ext_int`, `ext_vw`, `int_x`, `int_y`, `int_z`, `int_a`, `int_int`, `int_vw`, `safe_x`, `safe_y`, `safe_z`, `safe_a`, `safe_int`, `safe_vw`, `enabled`) VALUES
(1, 'Grottie Dealership', 1, 0, 250000, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1),
(2, '24/7', 1, 0, 250000, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);

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
  `material_cost` int(11) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `stock_capacity` int(11) NOT NULL DEFAULT 50,
  `admin_enabled` tinyint(4) NOT NULL DEFAULT 1,
  `owner_enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `material_cost` int(11) NOT NULL,
  `default_stock_capacity` int(11) NOT NULL DEFAULT 50,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `business_product_catalog`
--

INSERT INTO `business_product_catalog` (`id`, `business_type`, `product_name`, `product_key`, `price`, `material_cost`, `default_stock_capacity`, `enabled`) VALUES
(1, 1, 'Phone', 'phone', 500, 20, 50, 1),
(2, 1, 'Phonebook', 'phonebook', 150, 5, 50, 1),
(3, 1, 'Radio', 'radio', 300, 10, 50, 1),
(4, 1, 'Spray Can', 'spraycan', 250, 15, 50, 1),
(5, 1, 'Rope', 'rope', 100, 5, 50, 1),
(6, 1, 'Cigarettes', 'cigarettes', 25, 1, 100, 1),
(7, 1, 'Mask', 'mask', 300, 15, 50, 1),
(8, 1, 'Dice', 'dice', 50, 1, 50, 1),
(9, 1, 'Camera', 'camera', 200, 10, 50, 1),
(10, 1, 'Hotdog Sandwich', 'hotdog_sandwich', 25, 2, 100, 1),
(11, 1, 'Sprunk', 'sprunk', 15, 1, 100, 1),
(12, 1, 'Vehicle Lock - Alarm', 'vehlock_alarm', 1000, 50, 20, 1),
(13, 1, 'Vehicle Lock - Industrial', 'vehlock_industrial', 2500, 150, 20, 1),
(14, 2, 'Colt 45', 'weapon_22', 1500, 100, 20, 1),
(15, 2, 'Silenced Pistol', 'weapon_23', 2500, 150, 20, 1),
(16, 2, 'MP5', 'weapon_29', 6000, 400, 10, 1),
(17, 2, 'Armor 50', 'armor_50', 1000, 250, 20, 1),
(18, 7, 'Burger', 'burger', 25, 2, 100, 1),
(19, 7, 'Pizza', 'pizza', 30, 3, 100, 1),
(20, 7, 'Chicken Meal', 'chicken_meal', 35, 3, 100, 1),
(21, 7, 'Fries', 'fries', 15, 1, 100, 1),
(22, 7, 'Coffee', 'coffee', 10, 1, 100, 1),
(23, 7, 'Water', 'water', 10, 1, 100, 1);

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
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `factions`
--

CREATE TABLE `factions` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `leader_id` int(11) NOT NULL DEFAULT 0,
  `leader_name` varchar(24) NOT NULL DEFAULT 'Nobody',
  `motd` varchar(128) NOT NULL DEFAULT '',
  `safe_balance` int(11) NOT NULL DEFAULT 0,
  `enabled` int(11) NOT NULL DEFAULT 1,
  `safe_deposit_rank` int(11) NOT NULL DEFAULT 1,
  `safe_withdraw_rank` int(11) NOT NULL DEFAULT 6,
  `locker_deposit_rank` int(11) NOT NULL DEFAULT 1,
  `locker_withdraw_rank` int(11) NOT NULL DEFAULT 6,
  `locker_gun_rank` int(11) NOT NULL DEFAULT 1,
  `color` int(11) NOT NULL DEFAULT 865730559,
  `radio_color` int(11) NOT NULL DEFAULT 865730559
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `factions`
--

INSERT INTO `factions` (`id`, `name`, `leader_id`, `leader_name`, `motd`, `safe_balance`, `enabled`, `safe_deposit_rank`, `safe_withdraw_rank`, `locker_deposit_rank`, `locker_withdraw_rank`, `locker_gun_rank`, `color`, `radio_color`) VALUES
(1, 'LSPD', 0, 'Nobody', 'Welcome to the faction.', 0, 1, 1, 6, 1, 6, 1, 865730559, 865730559);

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
  `enabled` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `faction_locker_guns`
--

CREATE TABLE `faction_locker_guns` (
  `id` int(11) NOT NULL,
  `locker_id` int(11) NOT NULL,
  `weaponid` int(11) NOT NULL,
  `admin_enabled` int(11) NOT NULL DEFAULT 1,
  `leader_enabled` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `motd` varchar(128) NOT NULL DEFAULT '',
  `safe_deposit_rank` int(11) NOT NULL DEFAULT 1,
  `safe_withdraw_rank` int(11) NOT NULL DEFAULT 6,
  `locker_deposit_rank` int(11) NOT NULL DEFAULT 1,
  `locker_withdraw_rank` int(11) NOT NULL DEFAULT 6,
  `locker_gun_rank` int(11) NOT NULL DEFAULT 1,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `color` int(11) NOT NULL DEFAULT 869020671,
  `radio_color` int(11) NOT NULL DEFAULT 869020671
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `families`
--

INSERT INTO `families` (`id`, `name`, `leader_id`, `leader_name`, `motd`, `safe_deposit_rank`, `safe_withdraw_rank`, `locker_deposit_rank`, `locker_withdraw_rank`, `locker_gun_rank`, `enabled`, `color`, `radio_color`) VALUES
(1, 'Groove Street Families', 1, 'Jimmy_Richardson', 'Welcome to Groove', 1, 6, 1, 6, 1, 1, 869020671, 16777215);

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
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `family_lockers`
--

INSERT INTO `family_lockers` (`id`, `family_id`, `x`, `y`, `z`, `interior`, `vw`, `materials`, `enabled`) VALUES
(1, 1, 0, 0, 0, 0, 0, 10000, 1);

-- --------------------------------------------------------

--
-- Table structure for table `family_locker_guns`
--

CREATE TABLE `family_locker_guns` (
  `id` int(11) NOT NULL,
  `locker_id` int(11) NOT NULL,
  `weaponid` int(11) NOT NULL,
  `admin_enabled` tinyint(4) NOT NULL DEFAULT 1,
  `leader_enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `family_locker_guns`
--

INSERT INTO `family_locker_guns` (`id`, `locker_id`, `weaponid`, `admin_enabled`, `leader_enabled`) VALUES
(1, 1, 22, 1, 1),
(2, 1, 23, 1, 1),
(3, 1, 29, 1, 1),
(4, 1, 0, 1, 1),
(5, 1, 0, 1, 1),
(6, 1, 0, 1, 1),
(7, 1, 0, 1, 1),
(8, 1, 0, 1, 1),
(9, 1, 0, 1, 1),
(10, 1, 0, 1, 1);

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
(1, 1, 1, 'Rank 1'),
(2, 1, 2, 'Rank 2'),
(3, 1, 3, 'Rank 3'),
(4, 1, 4, 'Rank 4'),
(5, 1, 5, 'Rank 5'),
(6, 1, 6, 'Rank 6');

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
(1, 'County General Hospital', 0, 'Los Santos', 2383.07, 2662.05, 8001.15, 0, 1, 1001, 2380, 2660, 8001.15, 0, 1, 1001, 2385, 2662, 8001.15, 0, 1, 1001, 250, 150, 1000, 120, 60, 0, 1),
(2, 'All Saints General Hospital', 0, 'Los Santos', 2383.07, 2662.05, 8001.15, 0, 1, 1002, 2380, 2660, 8001.15, 0, 1, 1002, 2385, 2662, 8001.15, 0, 1, 1002, 250, 150, 1000, 120, 60, 0, 1);

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
  `vw` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hospital_beds`
--

INSERT INTO `hospital_beds` (`id`, `hospital_id`, `x`, `y`, `z`, `a`, `interior`, `vw`) VALUES
(1, 1, 2376, 2666, 8001.15, 90, 1, 1001),
(2, 1, 2376, 2668, 8001.15, 90, 1, 1001),
(3, 2, 2376, 2666, 8001.15, 90, 1, 1002),
(4, 2, 2376, 2668, 8001.15, 90, 1, 1002);

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
('DeathHPDecrease', '2.0'),
('DeathTickMS', '5000'),
('DefaultBank', '9000'),
('DefaultCash', '1000'),
('DefaultFemaleSkin', '12'),
('DefaultMaleSkin', '26'),
('DefaultSpawnA', '0.0'),
('DefaultSpawnInterior', '0'),
('DefaultSpawnVW', '0'),
('DefaultSpawnX', '1715.0687'),
('DefaultSpawnY', '-1899.5597'),
('DefaultSpawnZ', '13.5665'),
('Discord', ''),
('FamilyBackupBeaconTime', '120'),
('HospitalRespawnHP', '50.0'),
('JobLimitDefault', '1'),
('LoginTrack', 'https://excess-cyan-pqzenc7pdt.edgeone.app/Login.mp3'),
('News', 'Welcome to Express Roleplay - Gaming!'),
('RegisterTrack', 'https://scrawny-lime-ygxevngy6x.edgeone.app/Register.mp3'),
('ServerName', 'Express Roleplay - Gaming'),
('TutorialEnabled', '1'),
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
('Website', '');

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `owner_pid` int(11) NOT NULL DEFAULT 0,
  `family_id` int(11) NOT NULL DEFAULT 0,
  `faction_id` int(11) NOT NULL DEFAULT 0,
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

INSERT INTO `vehicles` (`id`, `owner_pid`, `family_id`, `faction_id`, `model`, `color1`, `color2`, `paintjob`, `x`, `y`, `z`, `a`, `interior`, `vw`, `lock_type`, `health`, `enabled`, `nos`, `mod_spoiler`, `mod_hood`, `mod_roof`, `mod_sideskirt_l`, `mod_sideskirt_r`, `mod_lamps`, `mod_nitro`, `mod_exhaust`, `mod_wheels`, `mod_stereo`, `mod_hydraulics`, `mod_front_bumper`, `mod_rear_bumper`, `mod_vent_right`, `mod_vent_left`, `unlimited_nos`) VALUES
(1, 1, 0, 0, 555, 234, 234, -1, 2516.71, -1671.86, 13.6467, 61.4398, 0, 0, 0, 1000, 1, 1010, 0, 0, 0, 0, 0, 0, 1010, 0, 1082, 0, 0, 0, 0, 0, 0, 1),
(2, 0, 0, 0, 559, 234, 234, 2, 2496.99, -1682.64, 13.064, 89.3899, 0, 0, 0, 1000, 1, 1010, 1162, 1066, 1067, 1071, 1072, 0, 1010, 0, 1084, 0, 0, 0, 0, 0, 0, 1),
(3, 0, 0, 0, 557, 234, 234, -1, 2526.86, -1667.59, 15.1689, 87.0024, 0, 0, 0, 1000, 1, 1010, 0, 0, 0, 0, 0, 0, 1010, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 0, 0, 0, 468, 234, 234, -1, 2499.6, -1652.28, 13.4975, 144.823, 0, 0, 0, 1000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 0, 0, 0, 468, 234, 234, -1, 2498.5, -1651.76, 13.1739, 144.989, 0, 0, 0, 1000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(6, 0, 0, 0, 560, 234, 234, 1, 2486.12, -1655.01, 13.0341, 90.7256, 0, 0, 0, 1000, 1, 1010, 1138, 0, 1033, 1031, 0, 1027, 1010, 0, 1080, 0, 1087, 1169, 0, 0, 0, 1),
(7, 0, 0, 0, 560, 234, 234, 1, 2487.62, -1682.33, 13.0407, 84.8677, 0, 0, 0, 1000, 1, 0, 1139, 0, 1032, 1026, 1027, 1027, 0, 1029, 0, 0, 0, 1169, 1140, 0, 0, 0),
(8, 0, 0, 0, 562, 234, 234, 1, 2496.38, -1654.87, 13.0967, 87.4942, 0, 0, 0, 1000, 1, 1010, 0, 0, 1035, 0, 0, 0, 1010, 0, 1082, 0, 0, 0, 0, 0, 0, 1),
(9, 0, 0, 0, 468, 234, 234, -1, 2471.73, -1685.82, 13.1771, 329.089, 0, 0, 0, 1000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 0, 0, 0, 468, 234, 234, -1, 2473.22, -1686.61, 13.177, 330.019, 0, 0, 0, 1000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(11, 0, 0, 0, 522, 234, 234, -1, 2513.31, -1679.67, 13.0526, 45.2271, 0, 0, 0, 1000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(12, 0, 0, 0, 558, 234, 234, 1, 2507.18, -1675.51, 13.0823, 144.593, 0, 0, 0, 1000, 1, 1010, 1163, 0, 1088, 0, 0, 0, 1010, 0, 1076, 0, 0, 0, 0, 0, 0, 1),
(13, 0, 0, 0, 559, 234, 234, 0, 2506.89, -1662.15, 13.1192, 33.8094, 0, 0, 0, 1000, 1, 1010, 1158, 0, 1067, 1069, 1070, 0, 1010, 0, 1077, 0, 0, 0, 0, 0, 0, 1),
(14, 0, 0, 0, 487, 234, 234, -1, 2528.31, -1678.05, 19.9302, 88.5881, 0, 0, 0, 1000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(15, 0, 0, 0, 411, 234, 234, -1, 2516.71, -1664.39, 13.6363, 105.578, 0, 0, 0, 1000, 1, 1010, 0, 0, 0, 0, 0, 0, 1010, 0, 1081, 0, 1087, 0, 0, 0, 0, 1),
(16, 0, 0, 0, 402, 234, 234, -1, 2473.77, -1701.56, 13.3541, 359.373, 0, 0, 0, 1000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(17, 0, 0, 0, 470, 234, 234, -1, 2505.67, -1695.11, 13.2831, 0.633741, 0, 0, 0, 1000, 1, 1010, 0, 0, 0, 0, 0, 0, 1010, 0, 0, 0, 0, 0, 0, 0, 0, 1),
(18, 1, 0, 0, 561, 234, 234, 2, 2477.09, -1654.98, 13.1057, 88.6701, 0, 0, 0, 1000, 1, 1010, 1158, 0, 1055, 1070, 0, 0, 1010, 0, 1083, 0, 0, 1155, 1156, 0, 0, 1),
(19, 0, 0, 0, 561, 234, 324, 2, 2475.55, -1679.82, 12.9997, 54.1611, 0, 0, 0, 1000, 1, 1010, 0, 0, 1061, 0, 0, 0, 1010, 0, 1073, 0, 0, 1155, 1156, 0, 0, 1),
(20, 0, 0, 0, 420, 6, 6, -1, 1776.41, -1858.88, 13.1912, 90.0757, 0, 0, 0, 1000, 1, 1010, 1003, 1005, 0, 0, 0, 0, 1010, 1021, 1082, 0, 0, 0, 0, 0, 0, 1),
(21, 0, 0, 0, 420, 6, 6, -1, 1786.57, -1858.88, 13.1931, 90.0757, 0, 0, 0, 1000, 1, 1010, 1003, 1005, 0, 0, 0, 0, 1010, 0, 1082, 0, 0, 0, 0, 0, 0, 1),
(22, 0, 0, 0, 420, 6, 6, -1, 1796.86, -1858.88, 13.1928, 90.0757, 0, 0, 0, 1000, 1, 1010, 1003, 1004, 0, 0, 0, 0, 1010, 1019, 1082, 0, 0, 0, 0, 0, 0, 1),
(23, 0, 0, 0, 420, 6, 6, -1, 1768.08, -1858.88, 13.1926, 90.0757, 0, 0, 0, 1000, 1, 1010, 1003, 1005, 0, 0, 0, 0, 1010, 1021, 1082, 0, 0, 0, 0, 0, 0, 1),
(24, 0, 0, 0, 466, 8, 0, -1, 1776.64, -1897.01, 13.1298, 272.479, 0, 0, 0, 1000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(25, 0, 0, 0, 466, 5, 0, -1, 1778.86, -1903.35, 13.3863, 267.868, 0, 0, 0, 1000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `weapon_material_costs`
--

CREATE TABLE `weapon_material_costs` (
  `weaponid` int(11) NOT NULL,
  `weapon_name` varchar(32) NOT NULL,
  `material_cost` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `weapon_material_costs`
--

INSERT INTO `weapon_material_costs` (`weaponid`, `weapon_name`, `material_cost`, `enabled`) VALUES
(0, 'Armor 50', 250, 1),
(22, 'Colt 45', 100, 1),
(23, 'Silenced Pistol', 150, 1),
(24, 'Desert Eagle', 600, 1),
(25, 'Shotgun', 500, 1),
(29, 'MP5', 400, 1),
(30, 'AK47', 900, 1),
(31, 'M4', 1000, 1),
(33, 'Rifle', 650, 1),
(34, 'Sniper', 1500, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `phone` (`phone`);

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
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `factions`
--
ALTER TABLE `factions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faction_divisions`
--
ALTER TABLE `faction_divisions`
  ADD PRIMARY KEY (`id`);

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
  ADD PRIMARY KEY (`id`);

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
  ADD PRIMARY KEY (`id`);

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
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `family_safes`
--
ALTER TABLE `family_safes`
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
  ADD PRIMARY KEY (`weaponid`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `business_products`
--
ALTER TABLE `business_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `business_product_catalog`
--
ALTER TABLE `business_product_catalog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `dealership_vehicles`
--
ALTER TABLE `dealership_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `factions`
--
ALTER TABLE `factions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `faction_divisions`
--
ALTER TABLE `faction_divisions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faction_lockers`
--
ALTER TABLE `faction_lockers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faction_locker_guns`
--
ALTER TABLE `faction_locker_guns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faction_ranks`
--
ALTER TABLE `faction_ranks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `family_lockers`
--
ALTER TABLE `family_lockers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `family_locker_guns`
--
ALTER TABLE `family_locker_guns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
-- AUTO_INCREMENT for table `hospitals`
--
ALTER TABLE `hospitals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `hospital_beds`
--
ALTER TABLE `hospital_beds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `radiostations`
--
ALTER TABLE `radiostations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;
-- =========================================================
-- ExpressRP full systems extension: limits, houses, doors, toys, businesses
-- Apply this after the base dump is imported.
-- =========================================================
ALTER TABLE `accounts`
  ADD COLUMN `max_vehicles` int(11) NOT NULL DEFAULT 0,
  ADD COLUMN `max_houses` int(11) NOT NULL DEFAULT 0,
  ADD COLUMN `max_businesses` int(11) NOT NULL DEFAULT 0,
  ADD COLUMN `max_toys` int(11) NOT NULL DEFAULT 0,
  ADD COLUMN `has_mp3` tinyint(4) NOT NULL DEFAULT 0;

ALTER TABLE `businesses`
  ADD COLUMN `owner_type` tinyint(4) NOT NULL DEFAULT 0 AFTER `type`,
  ADD COLUMN `owner_name` varchar(24) NOT NULL DEFAULT 'Nobody' AFTER `owner_id`,
  ADD COLUMN `price_mode` tinyint(4) NOT NULL DEFAULT 0 AFTER `price`,
  ADD COLUMN `pickup_model` int(11) NOT NULL DEFAULT 1274 AFTER `safe_vw`,
  ADD COLUMN `pickup_type` int(11) NOT NULL DEFAULT 1 AFTER `pickup_model`,
  ADD COLUMN `locked` tinyint(4) NOT NULL DEFAULT 0 AFTER `pickup_type`;
UPDATE `businesses` SET `owner_type`=IF(`owner_id`>0,1,0), `owner_name`='Nobody', `pickup_model`=1274, `pickup_type`=1, `locked`=0;

ALTER TABLE `factions`
  ADD COLUMN `type` tinyint(4) NOT NULL DEFAULT 0 AFTER `name`,
  ADD COLUMN `members_count` int(11) NOT NULL DEFAULT 0 AFTER `leader_name`,
  ADD COLUMN `division_color` int(11) NOT NULL DEFAULT 16776960 AFTER `radio_color`;
ALTER TABLE `families`
  ADD COLUMN `members_count` int(11) NOT NULL DEFAULT 0 AFTER `leader_name`,
  ADD COLUMN `crew_color` int(11) NOT NULL DEFAULT 16776960 AFTER `radio_color`;
ALTER TABLE `family_lockers`
  ADD COLUMN `pot` int(11) NOT NULL DEFAULT 0 AFTER `materials`,
  ADD COLUMN `crack` int(11) NOT NULL DEFAULT 0 AFTER `pot`;
ALTER TABLE `faction_lockers`
  ADD COLUMN `pot` int(11) NOT NULL DEFAULT 0 AFTER `materials`,
  ADD COLUMN `crack` int(11) NOT NULL DEFAULT 0 AFTER `pot`;
ALTER TABLE `family_locker_guns` ADD COLUMN `required_rank` tinyint(4) NOT NULL DEFAULT 1 AFTER `weaponid`;
ALTER TABLE `faction_locker_guns` ADD COLUMN `required_rank` tinyint(4) NOT NULL DEFAULT 1 AFTER `weaponid`;

UPDATE `business_product_catalog` SET `business_type`=4 WHERE `product_key` IN ('weapon_22','weapon_23','weapon_29','armor_50');
UPDATE `business_product_catalog` SET `business_type`=2 WHERE `product_key` IN ('burger','pizza','chicken_meal','fries','coffee','water');
INSERT INTO `business_product_catalog` (`id`, `business_type`, `product_name`, `product_key`, `price`, `material_cost`, `default_stock_capacity`, `enabled`) VALUES
(24, 1, 'MP3 Player', 'mp3', 500, 15, 50, 1),
(25, 1, 'GPS', 'gps', 350, 10, 50, 1),
(26, 1, 'Repair Kit', 'repairkit', 750, 40, 35, 1),
(27, 1, 'Fuel Can', 'fuelcan', 300, 10, 50, 1),
(28, 1, 'Phone Credit', 'phone_credit', 100, 0, 200, 1),
(29, 2, 'Taco', 'taco', 20, 2, 100, 1),
(30, 2, 'Salad', 'salad', 25, 2, 100, 1),
(31, 2, 'Soda', 'soda', 15, 1, 100, 1),
(32, 3, 'Clothes', 'clothes_access', 500, 5, 100, 1),
(33, 3, 'Toys', 'toys_access', 1000, 10, 100, 1),
(34, 4, 'Desert Eagle', 'weapon_24', 8000, 600, 10, 1),
(35, 4, 'Shotgun', 'weapon_25', 5000, 500, 10, 1),
(36, 4, 'Rifle', 'weapon_33', 8500, 650, 8, 1),
(37, 4, 'Ammo Pack', 'ammo_pack', 1200, 75, 50, 1),
(38, 4, 'Armor 100', 'armor_100', 2500, 500, 20, 1),
(39, 6, 'Beer', 'beer', 20, 1, 150, 1),
(40, 6, 'Wine', 'wine', 60, 4, 100, 1),
(41, 6, 'Whiskey', 'whiskey', 100, 5, 100, 1),
(42, 7, 'Fuel Can', 'fuelcan', 300, 10, 100, 1),
(43, 7, 'Repair Kit', 'repairkit', 750, 40, 50, 1),
(44, 7, 'Oil', 'oil', 200, 5, 100, 1),
(45, 7, 'Sprunk', 'sprunk', 15, 1, 150, 1),
(46, 8, 'Bank Services', 'bank_services', 0, 0, 9999, 1),
(47, 9, 'Gym Membership', 'gym_membership', 1000, 0, 100, 1),
(48, 9, 'Boxing Style', 'boxing_style', 2500, 0, 50, 1),
(49, 9, 'Martial Arts Style', 'martial_arts_style', 3500, 0, 50, 1);

INSERT INTO `weapon_material_costs` (`weaponid`, `weapon_name`, `material_cost`, `enabled`) VALUES
(4, 'Knife', 75, 1),
(5, 'Baseball Bat', 60, 1),
(8, 'Katana', 250, 1),
(9, 'Chainsaw', 750, 1),
(26, 'Sawed-off Shotgun', 650, 1),
(27, 'Combat Shotgun', 850, 1),
(28, 'Micro SMG', 350, 1),
(32, 'Tec-9', 350, 1),
(35, 'Rocket Launcher', 5000, 0),
(37, 'Flamethrower', 4000, 0),
(38, 'Minigun', 9999, 0),
(39, 'Satchel Charge', 2500, 0),
(41, 'Spray Can', 100, 1),
(42, 'Fire Extinguisher', 100, 1),
(43, 'Camera', 50, 1);

CREATE TABLE `houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `owner` (`owner_type`,`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `house_weapons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `house_id` int(11) NOT NULL,
  `weaponid` int(11) NOT NULL,
  `ammo` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `house_id` (`house_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `doors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `owner` (`owner_type`,`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `toy_catalog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `modelid` int(11) NOT NULL,
  `bone` int(11) NOT NULL DEFAULT 2,
  `price` int(11) NOT NULL DEFAULT 1000,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
INSERT INTO `toy_catalog` (`name`,`modelid`,`bone`,`price`,`enabled`) VALUES
('Cowboy Hat', 18962, 2, 1000, 1),
('Black Glasses', 19006, 2, 1200, 1),
('Bandana', 18911, 2, 800, 1),
('Backpack', 3026, 1, 2500, 1),
('Police Shield', 18637, 5, 3000, 1),
('Guitar', 19317, 1, 2500, 1),
('Briefcase', 1210, 6, 1500, 1),
('Phone Toy', 330, 6, 750, 1),
('Helmet', 18976, 2, 1500, 1),
('Mask', 19036, 2, 1800, 1);

CREATE TABLE `player_toys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `auto_wear` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `gas_pumps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_id` int(11) NOT NULL,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `business_id` (`business_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `servercore` (`keyname`,`value`) VALUES
('DefaultMaxVehicles','3'),
('DefaultMaxHouses','1'),
('DefaultMaxBusinesses','1'),
('DefaultMaxToys','5'),
('VipMaxVehicles0','3'),('VipMaxVehicles1','5'),('VipMaxVehicles2','8'),('VipMaxVehicles3','12'),('VipMaxVehicles4','15'),('VipMaxVehicles5','20'),
('VipMaxHouses0','1'),('VipMaxHouses1','2'),('VipMaxHouses2','3'),('VipMaxHouses3','5'),('VipMaxHouses4','7'),('VipMaxHouses5','10'),
('VipMaxBusinesses0','1'),('VipMaxBusinesses1','2'),('VipMaxBusinesses2','3'),('VipMaxBusinesses3','5'),('VipMaxBusinesses4','7'),('VipMaxBusinesses5','10'),
('VipMaxToys0','5'),('VipMaxToys1','8'),('VipMaxToys2','12'),('VipMaxToys3','20'),('VipMaxToys4','20'),('VipMaxToys5','20'),
('MaxFamilies','100'),('MaxFactions','100'),('MaxFamilyRanks','10'),('MaxFactionRanks','10'),('MaxFamilyCrews','5'),('MaxFactionDivisions','5');

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
