-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        10.1.20-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  9.4.0.5144
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 함수 explan_new.makeUniqueID 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `makeUniqueID`() RETURNS varchar(14) CHARSET utf8
    DETERMINISTIC
RETURN CONCAT(SUBSTRING((HEX(NOW() - 0)), 3, 10), SUBSTRING((FLOOR(RAND() * 10000) + 1000), 1, 4))//
DELIMITER ;

-- 테이블 explan_new.t_com_code 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_com_code` (
  `CODE_NUM` varchar(14) NOT NULL,
  `CODE_GROUP_NUM` varchar(14) DEFAULT NULL,
  `CODE_NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CODE_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_com_code:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_com_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_com_code` ENABLE KEYS */;

-- 테이블 explan_new.t_com_code_group 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_com_code_group` (
  `CODE_GROUP_NUM` varchar(14) NOT NULL,
  `GROUP_NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CODE_GROUP_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_com_code_group:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_com_code_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_com_code_group` ENABLE KEYS */;

-- 테이블 explan_new.t_com_common_code 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_com_common_code` (
  `COMMON_TCD` varchar(50) NOT NULL,
  `COMMON_CODE` varchar(20) NOT NULL,
  `COMMON_NAME` varchar(100) DEFAULT NULL,
  `ATTB1` varchar(100) DEFAULT NULL,
  `ATTB2` varchar(100) DEFAULT NULL,
  `ATTB3` varchar(100) DEFAULT NULL,
  `ORDER_SEQ` int(11) DEFAULT NULL,
  PRIMARY KEY (`COMMON_TCD`,`COMMON_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_com_common_code:~58 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_com_common_code` DISABLE KEYS */;
INSERT INTO `t_com_common_code` (`COMMON_TCD`, `COMMON_CODE`, `COMMON_NAME`, `ATTB1`, `ATTB2`, `ATTB3`, `ORDER_SEQ`) VALUES
	('GUARANTEE_TERM_TYPE', '년만기', '년만기', NULL, NULL, NULL, 2),
	('GUARANTEE_TERM_TYPE', '세만기', '세만기', NULL, NULL, NULL, 1),
	('IMMOVABLE_TYPE', '기타', '기타', NULL, NULL, NULL, 6),
	('IMMOVABLE_TYPE', '상가', '상가', NULL, NULL, NULL, 2),
	('IMMOVABLE_TYPE', '오피스텔', '오피스텔', NULL, NULL, NULL, 3),
	('IMMOVABLE_TYPE', '자동차', '자동차', NULL, NULL, NULL, 5),
	('IMMOVABLE_TYPE', '주택', '주택', NULL, NULL, NULL, 1),
	('IMMOVABLE_TYPE', '토지', '토지', NULL, NULL, NULL, 4),
	('INSURANCE_TYPE', '건강보험', '건강보험', NULL, NULL, NULL, 2),
	('INSURANCE_TYPE', '공제', '공제', NULL, NULL, NULL, 18),
	('INSURANCE_TYPE', '기타', '기타', NULL, NULL, NULL, 20),
	('INSURANCE_TYPE', '모름', '모름', NULL, NULL, NULL, 19),
	('INSURANCE_TYPE', '방카슈랑스', '방카슈랑스', NULL, NULL, NULL, 11),
	('INSURANCE_TYPE', '변액보험특약', '변액보험특약', NULL, NULL, NULL, 17),
	('INSURANCE_TYPE', '상해보험', '상해보험', NULL, NULL, NULL, 6),
	('INSURANCE_TYPE', '손해보험', '손해보험', NULL, NULL, NULL, 9),
	('INSURANCE_TYPE', '실손보험', '실손보험', NULL, NULL, NULL, 10),
	('INSURANCE_TYPE', '암보험', '암보험', NULL, NULL, NULL, 5),
	('INSURANCE_TYPE', '어린이보험', '어린이보험', NULL, NULL, NULL, 12),
	('INSURANCE_TYPE', '연금보험특약', '연금보험특약', NULL, NULL, NULL, 16),
	('INSURANCE_TYPE', '운전자보험', '운전자보험', NULL, NULL, NULL, 14),
	('INSURANCE_TYPE', '의료비보험', '의료비보험', NULL, NULL, NULL, 4),
	('INSURANCE_TYPE', '장기보험', '장기보험', NULL, NULL, NULL, 7),
	('INSURANCE_TYPE', '저축보험특약', '저축보험특약', NULL, NULL, NULL, 15),
	('INSURANCE_TYPE', '정기보험', '정기보험', NULL, NULL, NULL, 3),
	('INSURANCE_TYPE', '종신보험', '종신보험', NULL, NULL, NULL, 1),
	('INSURANCE_TYPE', '태아보험', '태아보험', NULL, NULL, NULL, 13),
	('INSURANCE_TYPE', '통합보험', '통합보험', NULL, NULL, NULL, 8),
	('INTEREST_TYPE', '단리', '단리', NULL, NULL, NULL, 1),
	('INTEREST_TYPE', '연복리', '연복리', NULL, NULL, NULL, 2),
	('INTEREST_TYPE', '월복리', '월복리', NULL, NULL, NULL, 3),
	('INVESTMENT_TYPE', '기타', '기타', '3', NULL, NULL, 7),
	('INVESTMENT_TYPE', '보험', '보험', '3', NULL, NULL, 6),
	('INVESTMENT_TYPE', '예금', '예금', '1', NULL, NULL, 2),
	('INVESTMENT_TYPE', '적금', '적금', '1', NULL, NULL, 1),
	('INVESTMENT_TYPE', '주식', '주식', '2', NULL, NULL, 5),
	('INVESTMENT_TYPE', '펀드', '펀드', '2', NULL, NULL, 4),
	('LOAN_TYPE', '기타', '기타', NULL, NULL, NULL, 11),
	('LOAN_TYPE', '마이너스대출', '마이너스대출', NULL, NULL, NULL, 7),
	('LOAN_TYPE', '보증금', '보증금', NULL, NULL, NULL, 9),
	('LOAN_TYPE', '신용대출', '신용대출', NULL, NULL, NULL, 3),
	('LOAN_TYPE', '전세보증금', '전세보증금', NULL, NULL, NULL, 10),
	('LOAN_TYPE', '전세자금대출', '전세자금대출', NULL, NULL, NULL, 2),
	('LOAN_TYPE', '주택담보대출', '주택담보대출', NULL, NULL, NULL, 1),
	('LOAN_TYPE', '지인한테빌림', '지인한테빌림', NULL, NULL, NULL, 8),
	('LOAN_TYPE', '직접입력', '직접입력', NULL, NULL, NULL, 12),
	('LOAN_TYPE', '카드대출', '카드대출', NULL, NULL, NULL, 4),
	('LOAN_TYPE', '학자금대출', '학자금대출', NULL, NULL, NULL, 5),
	('LOAN_TYPE', '할부금', '할부금', NULL, NULL, NULL, 6),
	('PAYBACK_TYPE', '만기일시상환', '만기일시상환', NULL, NULL, NULL, 1),
	('PAYBACK_TYPE', '원금균등상환', '원금균등상환', NULL, NULL, NULL, 3),
	('PAYBACK_TYPE', '원리금균등상환', '원리금균등상환', NULL, NULL, NULL, 2),
	('PAYBACK_TYPE', '자유상환', '자유상환', NULL, NULL, NULL, 4),
	('PAY_TERM_TYPE', '년납', '년납', NULL, NULL, NULL, 1),
	('PAY_TERM_TYPE', '세납', '세납', NULL, NULL, NULL, 2),
	('PLAN_TYPE', '기본', '기본', NULL, NULL, NULL, 1),
	('PLAN_TYPE', '제안', '제안', NULL, NULL, NULL, 2),
	('TAX', '1.4', '1.4', NULL, NULL, NULL, 2),
	('TAX', '15.4', '15.4', NULL, NULL, NULL, 1),
	('TAX', '비과세', '비과세', NULL, NULL, NULL, 3);
/*!40000 ALTER TABLE `t_com_common_code` ENABLE KEYS */;

-- 테이블 explan_new.t_com_customer 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_com_customer` (
  `CUSTOMER_NUM` varchar(14) NOT NULL,
  `CUSTOMER_NAME` varchar(20) DEFAULT NULL,
  `BIRTHDAY` varchar(8) DEFAULT NULL,
  `USER_ID` varchar(20) DEFAULT NULL,
  `PHONE_NUM` varchar(14) DEFAULT NULL,
  `EMAIL` varchar(50) DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  `DEL_YN` varchar(1) DEFAULT 'N',
  `DEL_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`CUSTOMER_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_com_customer:~12 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_com_customer` DISABLE KEYS */;
INSERT INTO `t_com_customer` (`CUSTOMER_NUM`, `CUSTOMER_NAME`, `BIRTHDAY`, `USER_ID`, `PHONE_NUM`, `EMAIL`, `CREATE_DATE`, `DEL_YN`, `DEL_DATE`) VALUES
	('014da8f0b49e56', 'ddd', '', 'jonsaram', '', '', '2015-05-31 16:47:36', 'Y', NULL),
	('1', '위성열1', '19741222', 'jonsaram', '010-3252-3102', 'jonnom@nate.com', '2015-01-14 23:43:32', 'N', NULL),
	('14da7cf1dcc30c', '1테스트', '20150708', 'jonsaram', '010-6231-0124', '', '2015-05-31 11:31:18', 'Y', NULL),
	('14da802301729b', '1ssss', '', 'jonsaram', '', '', '2015-05-31 12:27:05', 'Y', NULL),
	('14da8eee3c319f', 's', '', 'jonsaram', '', '', '2015-05-31 16:45:37', 'Y', NULL),
	('14da8ef4b6816e', 'd', '', 'jonsaram', '', '', '2015-05-31 16:46:04', 'Y', NULL),
	('14da8f6bbcd328', 'fv', '', 'jonsaram', '', '', '2015-05-31 16:54:11', 'Y', NULL),
	('14da8fb640a2b9', '1234', '', 'jonsaram', '', '', '2015-05-31 16:59:17', 'Y', NULL),
	('14f685c90c6e40', '위성열2', '741222', 'jonsaram', '010-3252-3102', 'jonnom@nate.com', '2015-08-26 13:55:41', 'Y', NULL),
	('152cefa05363e8', '위성열3', '19741222', 'jonsaram', '010-3252-3102', 'jonnom@nate.com', '2016-02-11 15:17:18', 'N', NULL),
	('152cefc7db7294', '문공주', '19741222', 'jonsaram', '010-3252-3102', 'jonnom@nate.com', '2016-02-11 15:19:59', 'Y', NULL),
	('159aae59800950', '위성열2', '19741222', 'jonsaram', '010-3252-3102', 'jonnom@nate.com', '2017-01-17 14:28:10', 'Y', NULL);
/*!40000 ALTER TABLE `t_com_customer` ENABLE KEYS */;

-- 테이블 explan_new.t_com_financy_plan_link 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_com_financy_plan_link` (
  `PLAN_NUM` varchar(14) NOT NULL,
  `FINANCY_NUM` varchar(14) NOT NULL,
  `STATE` char(1) DEFAULT NULL,
  `FINANCY_TYPE` char(1) NOT NULL,
  `CREATE_DATE` datetime NOT NULL,
  `MOD_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`PLAN_NUM`,`FINANCY_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_com_financy_plan_link:~41 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_com_financy_plan_link` DISABLE KEYS */;
INSERT INTO `t_com_financy_plan_link` (`PLAN_NUM`, `FINANCY_NUM`, `STATE`, `FINANCY_TYPE`, `CREATE_DATE`, `MOD_DATE`) VALUES
	('14dae5c77e91f6', '14f68d18c68132', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('14dae5c77e91f6', '14f921ba92f182', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('14dae5c77e91f6', '150640c980a550', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('14dae5c77e91f6', '159cfe3099235e', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('14dae5c77e91f6', '159cfe95e86246', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('14dae5c77e91f6', '159cfeb637b120', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('14dae5c77e91f6', '159cfed99a7250', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('14dae5c77e91f6', '159cfeeb7db1b2', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('14dae5c77e91f6', '15a180ea9c115d', '', 'V', '2017-02-07 19:11:38', '2017-03-02 15:22:31'),
	('14dae5c77e91f6', '15a180ea9c33ac', '', 'V', '2017-02-07 19:11:38', '2017-03-02 15:22:31'),
	('14dae5c77e91f6', '15a180ea9c5274', '', 'V', '2017-02-07 19:11:38', '2017-03-02 15:22:31'),
	('14dae5c77e91f6', '15a184fa5902dc', '', 'M', '2017-02-07 20:22:37', '2017-02-07 20:22:44'),
	('14dae5c77e91f6', '15a184ffbbf109', '', 'M', '2017-02-07 20:22:59', '2017-02-08 15:16:21'),
	('14dae5c77e91f6', '15a184ffbc0314', '', 'M', '2017-02-07 20:22:59', NULL),
	('14dae5c77e91f6', '15a186722ba23e', '', 'M', '2017-02-07 20:48:16', NULL),
	('14dae5c77e91f6', '15a186722be1de', '', 'M', '2017-02-07 20:48:16', NULL),
	('14dae5c77e91f6', '15a18688f881c3', '', 'M', '2017-02-07 20:49:50', NULL),
	('14dae5c77e91f6', '15a1868b093c20', '', 'M', '2017-02-07 20:49:58', '2017-02-07 20:50:17'),
	('14dae5c77e91f6', '15a1c629364378', '', 'M', '2017-02-08 15:21:46', '2017-02-16 14:03:22'),
	('14dae5c77e91f6', '15a1c63e2a3188', '', 'M', '2017-02-08 15:23:12', '2017-02-08 17:51:31'),
	('14dae5c77e91f6', '15a1d476767331', '', 'L', '2017-02-08 19:31:43', NULL),
	('14dae5c77e91f6', '15a1d4ada77214', '', 'L', '2017-02-08 19:35:29', '2017-02-08 19:36:34'),
	('14dae5c77e91f6', '15a1d4bd7dc218', '', 'L', '2017-02-08 19:36:34', '2017-02-08 19:36:48'),
	('14dae5c77e91f6', '15a1d4bd7dd3be', '', 'L', '2017-02-08 19:36:34', '2017-02-08 19:36:48'),
	('14dae5c77e91f6', '15a1d4c0e9e318', '', 'L', '2017-02-08 19:36:48', NULL),
	('14dae5c77e91f6', '15a21dbc236226', '', 'M', '2017-02-09 16:52:14', '2017-03-20 14:20:35'),
	('14dae5c77e91f6', '15a21de96bc300', '', 'M', '2017-02-09 16:55:20', NULL),
	('14dae5c77e91f6', '15a22e01d213ff', '', 'L', '2017-02-09 21:36:37', '2017-02-10 17:51:01'),
	('14dae5c77e91f6', '15a25c6bc902e1', '', 'L', '2017-02-10 11:07:45', '2017-02-10 17:50:08'),
	('14dae5c77e91f6', '15a2762eedf3df', '', 'L', '2017-02-10 18:37:59', '2017-03-16 10:28:42'),
	('14dae5c77e91f6', '15a3b9f9e7c14c', '', 'L', '2017-02-14 16:56:40', '2017-02-14 16:58:17'),
	('14dae5c77e91f6', '15a454dac462b4', '', 'M', '2017-02-16 14:03:22', NULL),
	('14dae5c77e91f6', '15aea03d5f829b', '', 'M', '2017-03-20 13:40:04', NULL),
	('14dae5c77e91f6', '15aea28ed73335', '', 'M', '2017-03-20 14:20:35', NULL),
	('14dae63109d180', '1508d42776b3c0', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('14dbd526e62394', '15a1873ebbc231', '', 'M', '2017-02-07 21:02:14', NULL),
	('14dbd526e62394', '15a1873ebbf26f', '', 'M', '2017-02-07 21:02:14', NULL),
	('14dbd526e62394', '15a18745f17148', '', 'M', '2017-02-07 21:02:44', NULL),
	('152ceff202b3f5', '159aaef02e0249', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('152ceff202b3f5', '159cfae01b038a', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('152ceff202b3f5', '159cfd089232c0', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('152ceff202b3f5', '159cfeb2befb00', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('152ceff202b3f5', '159cffa944c198', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('152ceff202b3f5', '159cfff883f2aa', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	('152ceff202b3f5', '159d00bf516150', '', 'I', '0000-00-00 00:00:00', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `t_com_financy_plan_link` ENABLE KEYS */;

-- 테이블 explan_new.t_com_main_menu 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_com_main_menu` (
  `MAIN_MENU_ID` varchar(20) NOT NULL,
  `MAIN_MENU_NAME` varchar(40) DEFAULT NULL,
  `SORT_ORDER` int(11) DEFAULT NULL,
  PRIMARY KEY (`MAIN_MENU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_com_main_menu:~5 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_com_main_menu` DISABLE KEYS */;
INSERT INTO `t_com_main_menu` (`MAIN_MENU_ID`, `MAIN_MENU_NAME`, `SORT_ORDER`) VALUES
	('CUSTOMER', '고객', 1),
	('FINANCY', '재무', 2),
	('INSURANCE', '보험', 3),
	('PURPOSE', '재무목표', 4),
	('REPORT', '통합보고서', 5);
/*!40000 ALTER TABLE `t_com_main_menu` ENABLE KEYS */;

-- 테이블 explan_new.t_com_member 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_com_member` (
  `USER_ID` varchar(20) NOT NULL,
  `USER_NAME` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_com_member:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_com_member` DISABLE KEYS */;
INSERT INTO `t_com_member` (`USER_ID`, `USER_NAME`) VALUES
	('jonsaram', '위성열');
/*!40000 ALTER TABLE `t_com_member` ENABLE KEYS */;

-- 테이블 explan_new.t_com_page_info 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_com_page_info` (
  `PAGE_ID` varchar(20) NOT NULL,
  `URL` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`PAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_com_page_info:~15 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_com_page_info` DISABLE KEYS */;
INSERT INTO `t_com_page_info` (`PAGE_ID`, `URL`) VALUES
	('BLANK_TEMPLATE', 'explan/template/blankTemplate'),
	('CASHFLOW_ANALYSIS', 'explan/financy/cashflowAnalysis'),
	('CASHFLOW_MANAGE', 'explan/financy/cashflowManage'),
	('CUSTOMER_LIST', 'explan/customer/customerList'),
	('FINANCY_ANALYSIS', 'explan/financy/financyAnalysis'),
	('IMMOVABLE_MANAGE', 'explan/financy/immovableManage'),
	('INSURANCE_ANALYSIS', 'explan/insurance/insuranceAnalysis'),
	('INSURANCE_MANAGE', 'explan/insurance/insuranceManage'),
	('INS_COMPARE_ANALYSIS', 'explan/insurance/insuranceCompareAnalysis'),
	('INVESTMENT_MANAGE', 'explan/financy/investmentManage'),
	('LOAN_MANAGE', 'explan/financy/loanManage'),
	('NORMAL_TEMPLATE', 'explan/template/normalTemplate'),
	('REPORT_MANAGE', 'explan/report/reportManage'),
	('REPORT_PRINT_PAGE', 'explan/report/reportPrintPage'),
	('SAMPLE', 'explan/sample/sample'),
	('SAMPLE_MULTIHEADER', 'explan/sample/sample_multiheader'),
	('TAB_TEMPLATE', 'explan/template/tabTemplate');
/*!40000 ALTER TABLE `t_com_page_info` ENABLE KEYS */;

-- 테이블 explan_new.t_com_plan 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_com_plan` (
  `PLAN_NUM` varchar(14) NOT NULL,
  `VERSION_SEQ` varchar(2) DEFAULT NULL,
  `CUSTOMER_NUM` varchar(14) DEFAULT NULL,
  `PLAN_NAME` varchar(50) DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  `START_DATE` varchar(8) DEFAULT NULL,
  `PLAN_TYPE` varchar(4) NOT NULL DEFAULT '기본',
  `BASE_PLAN_NUM` varchar(14) DEFAULT NULL,
  `USE_YN` varchar(1) DEFAULT 'Y',
  `DEL_YN` varchar(1) DEFAULT 'N',
  `DEL_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`PLAN_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_com_plan:~19 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_com_plan` DISABLE KEYS */;
INSERT INTO `t_com_plan` (`PLAN_NUM`, `VERSION_SEQ`, `CUSTOMER_NUM`, `PLAN_NAME`, `CREATE_DATE`, `START_DATE`, `PLAN_TYPE`, `BASE_PLAN_NUM`, `USE_YN`, `DEL_YN`, `DEL_DATE`) VALUES
	('14dae5c77e91f6', '1', '1', '기본플랜', '2015-06-01 18:03:25', '20170301', '기본', '', 'Y', 'N', NULL),
	('14dae63109d180', '1', '014da8f0b49e56', '기본플랜', '2015-06-01 18:10:37', '20150601', '기본', NULL, 'Y', 'N', NULL),
	('14dae636ada3c6', '1', '14da7cf1dcc30c', '기본플랜', '2015-06-01 18:11:00', '20150601', '기본', NULL, 'Y', 'N', NULL),
	('14db2161ff3390', '1', '14da8f6bbcd328', '기본플랜', '2015-06-02 11:25:03', '20150602', '기본', NULL, 'Y', 'N', NULL),
	('14dbc96389ae20', NULL, '14da8f6bbcd328', '1', '2015-06-04 12:21:11', '2', '기본', NULL, 'Y', 'Y', NULL),
	('14dbd3e913f23d', NULL, '14da8f6bbcd328', '1플랜', '2015-06-04 15:25:03', '20150602', '기본', NULL, 'Y', 'Y', NULL),
	('14dbd3e91ca27b', NULL, '14da8f6bbcd328', '2플랜', '2015-06-04 15:25:03', '20150602', '기본', NULL, 'Y', 'N', NULL),
	('14dbd44dd7b188', '1', '14da8fb640a2b9', '기본플랜', '2015-06-04 15:31:56', '20150604', '기본', NULL, 'Y', 'N', NULL),
	('14dbd4975df1f3', NULL, '14da8f6bbcd328', '3플랜', '2015-06-04 15:36:57', '20150602', '기본', NULL, 'Y', 'N', NULL),
	('14dbd526e62394', NULL, '1', '1234', '2015-06-04 15:46:45', '20150601', '기본', '', 'Y', 'N', NULL),
	('14dbd9dd8b42f0', NULL, '1', '1111', '2015-06-04 17:09:08', '20150601', '기본', NULL, 'Y', 'Y', NULL),
	('14dc1792a41150', '1', '14da802301729b', '기본플랜', '2015-06-05 11:07:32', '20150605', '기본', NULL, 'Y', 'N', NULL),
	('14dc17952b7285', '1', '14da8ef4b6816e', '기본플랜', '2015-06-05 11:07:43', '20150605', '기본', NULL, 'Y', 'N', NULL),
	('152ceff202b3f5', '1', '152cefa05363e8', '기본플랜', '2016-02-11 15:22:52', '20160211', '기본', NULL, 'Y', 'N', NULL),
	('159cf440b7d15d', '1', NULL, '기본플랜', '2017-01-24 15:57:40', NULL, '기본', NULL, 'Y', 'N', NULL),
	('15a21a937073c5', '1', NULL, '기본플랜', '2017-02-09 15:57:02', NULL, '기본', NULL, 'Y', 'N', NULL),
	('15a21aacfaa2c1', '1', NULL, '기본플랜', '2017-02-09 15:58:46', NULL, '기본', NULL, 'Y', 'N', NULL),
	('15a21ab1f92780', '1', NULL, '기본플랜', '2017-02-09 15:59:07', NULL, '기본', NULL, 'Y', 'N', NULL),
	('15a21addbc6369', '1', NULL, '기본플랜', '2017-02-09 16:02:06', NULL, '기본', NULL, 'Y', 'N', NULL);
/*!40000 ALTER TABLE `t_com_plan` ENABLE KEYS */;

-- 테이블 explan_new.t_com_sub_menu 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_com_sub_menu` (
  `SUB_MENU_ID` varchar(20) NOT NULL,
  `SUB_MENU_NAME` varchar(60) DEFAULT NULL,
  `MAIN_MENU_ID` varchar(20) NOT NULL,
  `PAGE_ID` varchar(20) DEFAULT NULL,
  `SORT_ORDER` int(11) DEFAULT NULL,
  PRIMARY KEY (`SUB_MENU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_com_sub_menu:~14 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_com_sub_menu` DISABLE KEYS */;
INSERT INTO `t_com_sub_menu` (`SUB_MENU_ID`, `SUB_MENU_NAME`, `MAIN_MENU_ID`, `PAGE_ID`, `SORT_ORDER`) VALUES
	('CSH_ANS', '현금흐름분석', 'FINANCY', 'CASHFLOW_ANALYSIS', 6),
	('CSH_MNG', '현금흐름관리', 'FINANCY', 'CASHFLOW_MANAGE', 4),
	('CST_MNG', '고객관리', 'CUSTOMER', 'CUSTOMER_LIST', 1),
	('FIN_ANS', '자산분석', 'FINANCY', 'FINANCY_ANALYSIS', 5),
	('FIN_COMP', '자산비교분석', 'FINANCY', '', 7),
	('IMM_MNG', '부동산관리', 'FINANCY', 'IMMOVABLE_MANAGE', 2),
	('INS_ANS', '보험분석', 'INSURANCE', 'INSURANCE_ANALYSIS', 2),
	('INS_COMP', '보험비교분석', 'INSURANCE', 'INS_COMPARE_ANALYSIS', 3),
	('INS_MNG', '보험관리', 'INSURANCE', 'INSURANCE_MANAGE', 1),
	('IVM_MNG', '금융자산관리', 'FINANCY', 'INVESTMENT_MANAGE', 1),
	('LON_MNG', '부채관리', 'FINANCY', 'LOAN_MANAGE', 3),
	('PUR_MNG', '재무목표등록/수정', 'PURPOSE', '', 1),
	('REP_MNG', '통합보고서출력', 'REPORT', 'REPORT_MANAGE', 1),
	('SMS_MNG', 'SMS관리', 'CUSTOMER', '', 2);
/*!40000 ALTER TABLE `t_com_sub_menu` ENABLE KEYS */;

-- 테이블 explan_new.t_fin_cashflow 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_fin_cashflow` (
  `PLAN_NUM` varchar(14) NOT NULL,
  `ITEM_NAME` varchar(20) NOT NULL,
  `ITEM_VALUE` int(11) DEFAULT NULL,
  `ITEM_TYPE` varchar(2) NOT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  `UPDATE_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`PLAN_NUM`,`ITEM_NAME`,`ITEM_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_fin_cashflow:~14 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_fin_cashflow` DISABLE KEYS */;
INSERT INTO `t_fin_cashflow` (`PLAN_NUM`, `ITEM_NAME`, `ITEM_VALUE`, `ITEM_TYPE`, `CREATE_DATE`, `UPDATE_DATE`) VALUES
	('14dae5c77e91f6', '고정지출', 88, 'CF', '2017-02-24 13:49:41', NULL),
	('14dae5c77e91f6', '공과금', NULL, 'CF', '2017-03-03 17:21:14', '2017-03-06 16:12:44'),
	('14dae5c77e91f6', '관리비', NULL, 'CF', '2017-03-06 13:20:06', '2017-03-06 16:12:44'),
	('14dae5c77e91f6', '근로소득', 1600, 'IL', '2017-02-23 17:19:42', '2017-02-24 16:44:43'),
	('14dae5c77e91f6', '금융소득', NULL, 'IL', '2017-02-24 13:49:41', '2017-02-24 16:44:43'),
	('14dae5c77e91f6', '기타', 1, 'CF', '2017-03-06 16:16:12', NULL),
	('14dae5c77e91f6', '기타', 2, 'CV', '2017-03-06 16:16:12', NULL),
	('14dae5c77e91f6', '기타', 120, 'CY', '2017-03-06 13:20:06', '2017-03-06 16:36:10'),
	('14dae5c77e91f6', '기타소득', NULL, 'IL', '2017-02-24 13:49:41', '2017-02-24 16:44:43'),
	('14dae5c77e91f6', '기타지출', 22, 'CV', '2017-02-24 14:18:09', '2017-02-24 15:33:27'),
	('14dae5c77e91f6', '명절(추석/설 등) 비용', NULL, 'CY', '2017-03-06 14:45:32', '2017-03-06 16:12:44'),
	('14dae5c77e91f6', '변동지출', 99, 'CV', '2017-02-24 13:49:41', NULL),
	('14dae5c77e91f6', '사업소득', 300, 'IL', '2017-02-23 17:20:03', '2017-02-27 15:24:39'),
	('14dae5c77e91f6', '생활/가전비', NULL, 'CV', '2017-03-13 10:30:51', '2017-03-20 10:07:46'),
	('14dae5c77e91f6', '세금(재산세/자동차세 등)', 1200, 'CY', '2017-03-16 17:08:13', '2017-03-16 17:08:50'),
	('14dae5c77e91f6', '연금소득', NULL, 'IL', '2017-02-24 13:49:41', '2017-02-24 16:44:43'),
	('14dae5c77e91f6', '월세', NULL, 'CF', '2017-03-06 13:20:06', '2017-03-06 16:12:44'),
	('14dae5c77e91f6', '임대소득', NULL, 'IL', '2017-02-23 17:20:03', '2017-02-24 16:44:16');
/*!40000 ALTER TABLE `t_fin_cashflow` ENABLE KEYS */;

-- 테이블 explan_new.t_fin_category 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_fin_category` (
  `CATEGORY_NUM` varchar(14) NOT NULL,
  `CATEGORY_NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CATEGORY_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_fin_category:~11 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_fin_category` DISABLE KEYS */;
INSERT INTO `t_fin_category` (`CATEGORY_NUM`, `CATEGORY_NAME`) VALUES
	('11', '사망보험금'),
	('12', '장해보상금'),
	('13', '진단비'),
	('14', '수술비'),
	('15', '치료비'),
	('16', '입원비'),
	('17', '실손보상'),
	('18', '운전자보험'),
	('19', 'CI'),
	('20', '어린이(태아)'),
	('21', '기타');
/*!40000 ALTER TABLE `t_fin_category` ENABLE KEYS */;

-- 테이블 explan_new.t_fin_dambo 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_fin_dambo` (
  `DAMBO_NUM` varchar(14) NOT NULL,
  `CATEGORY_NUM` varchar(14) NOT NULL,
  `DAMBO_NAME` varchar(50) DEFAULT NULL,
  `USER_ID` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`DAMBO_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_fin_dambo:~163 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_fin_dambo` DISABLE KEYS */;
INSERT INTO `t_fin_dambo` (`DAMBO_NUM`, `CATEGORY_NUM`, `DAMBO_NAME`, `USER_ID`) VALUES
	('1101', '11', '일반사망(종신)', '*common*'),
	('1102', '11', '일반사망(정기)', '*common*'),
	('1103', '11', '재해/상해사망', '*common*'),
	('1104', '11', '재해/상해사망(추가1)', '*common*'),
	('1105', '11', '재해/상해사망(추가2)', '*common*'),
	('1106', '11', '교통재해/상해사망', '*common*'),
	('1107', '11', '질병사망', '*common*'),
	('1108', '11', '암사망', '*common*'),
	('1201', '12', '재해/상해80%이상후유장해', '*common*'),
	('1202', '12', '재해/상해50%이상후유장해', '*common*'),
	('1203', '12', '재해/상해장해급여금', '*common*'),
	('1204', '12', '재해/상해후유장해급여금', '*common*'),
	('1205', '12', '교통재해/상해장해급여금', '*common*'),
	('1206', '12', '휴일재해/상해장해급여금', '*common*'),
	('1207', '12', '휴일교통재해/상해장해급여금', '*common*'),
	('1208', '12', '대중교통이용중재해/상해', '*common*'),
	('1301', '13', '일반암', '*common*'),
	('1302', '13', '고액암', '*common*'),
	('1303', '13', '경계성종양', '*common*'),
	('1304', '13', '상피내암', '*common*'),
	('1305', '13', '기타피부암', '*common*'),
	('1306', '13', '갑상샘암', '*common*'),
	('1307', '13', '남성3대암', '*common*'),
	('1308', '13', '여성3대암', '*common*'),
	('1309', '13', '여성특정암', '*common*'),
	('1310', '13', '5대다빈도암', '*common*'),
	('1311', '13', '뇌혈관', '*common*'),
	('1312', '13', '뇌졸중', '*common*'),
	('1313', '13', '뇌경색', '*common*'),
	('1314', '13', '뇌출혈', '*common*'),
	('1315', '13', '허혈성심장질환', '*common*'),
	('1316', '13', '급성심근경색', '*common*'),
	('1317', '13', '재해골절', '*common*'),
	('1318', '13', '재해화상', '*common*'),
	('1319', '13', '중증화상/부식', '*common*'),
	('1320', '13', '개호간병/치매', '*common*'),
	('1321', '13', '중증치매', '*common*'),
	('1322', '13', '말기폐질환진단', '*common*'),
	('1323', '13', '말기간경화진단', '*common*'),
	('1324', '13', '말기신부전증진단', '*common*'),
	('1401', '14', '질병', '*common*'),
	('1402', '14', '재해', '*common*'),
	('1403', '14', '질병/재해', '*common*'),
	('1404', '14', '1종~6종(3종,5종)', '*common*'),
	('1405', '14', '일반암', '*common*'),
	('1406', '14', '상피내암, 기타피부암', '*common*'),
	('1407', '14', '경계성종양', '*common*'),
	('1408', '14', '갑상샘암', '*common*'),
	('1409', '14', '주요질환', '*common*'),
	('1410', '14', '7대질환', '*common*'),
	('1411', '14', '10대질환', '*common*'),
	('1412', '14', '12대질환', '*common*'),
	('1413', '14', '16대질환', '*common*'),
	('1414', '14', '재해골절', '*common*'),
	('1415', '14', '재해화상', '*common*'),
	('1416', '14', '상해흉터복원', '*common*'),
	('1417', '14', '중대상해', '*common*'),
	('1418', '14', '성형수술비', '*common*'),
	('1419', '14', '성별특정질환', '*common*'),
	('1420', '14', '남성특정질병(질환)', '*common*'),
	('1421', '14', '여성특정질병(질환)', '*common*'),
	('1422', '14', '여성전용질환', '*common*'),
	('1423', '14', '부인과질환수술비', '*common*'),
	('1424', '14', '여성만성질병수술비', '*common*'),
	('1425', '14', '갑상샘질환수술비', '*common*'),
	('1426', '14', '장기이식', '*common*'),
	('1427', '14', '조혈모세포이식', '*common*'),
	('1428', '14', '각막이식', '*common*'),
	('14ffe081ec018b', '11', '11122', 'jonsaram'),
	('14ffe0857d5208', '11', '222', 'jonsaram'),
	('1501', '15', '방사선/항암약물치료비', '*common*'),
	('1502', '15', '질병특정고도장해재활치료비', '*common*'),
	('1503c332685180', '14', 'aaa4567', 'jonsaram'),
	('1503c3326872d1', '11', '222333', 'jonsaram'),
	('1601', '16', '질병/재해입원(1일부터)', '*common*'),
	('1602', '16', '질병/재해입원(4일부터)', '*common*'),
	('1603', '16', '재해/상해입원(1일부터)', '*common*'),
	('1604', '16', '재해/상해입원(4일부터)', '*common*'),
	('1605', '16', '교통재해입원(4일부터)', '*common*'),
	('1606', '16', '질병입원(1일부터)', '*common*'),
	('1607', '16', '질병입원(4일부터)', '*common*'),
	('1608', '16', '상해입원(31일,91일부터)', '*common*'),
	('1609', '16', '질병입원(31일,91일부터)', '*common*'),
	('1610', '16', '일반암입원', '*common*'),
	('1611', '16', '상피내암입원', '*common*'),
	('1612', '16', '경계성종양입원', '*common*'),
	('1613', '16', '기타피부암입원', '*common*'),
	('1614', '16', '갑상샘암', '*common*'),
	('1615', '16', '2대암입원', '*common*'),
	('1616', '16', '3대암입원', '*common*'),
	('1617', '16', '주요질환입원', '*common*'),
	('1618', '16', '성별특정질환입원', '*common*'),
	('1619', '16', '남성특정질병(질환)입원', '*common*'),
	('1620', '16', '여성특정질병(질환)입원', '*common*'),
	('1621', '16', '여성전용질환입원', '*common*'),
	('1622', '16', '부인과질환입원', '*common*'),
	('1623', '16', '7대~16대질환입원', '*common*'),
	('1624', '16', '1종~6종(3종,5종)질병입원', '*common*'),
	('1625', '16', '일반상해간병비', '*common*'),
	('1626', '16', '교통상해간병비', '*common*'),
	('1627', '16', '질병간병비', '*common*'),
	('1628', '16', '치매간병비', '*common*'),
	('1701', '17', '상해의료비', '*common*'),
	('1702', '17', '상해입원의료비', '*common*'),
	('1703', '17', '상해통원의료비', '*common*'),
	('1704', '17', '질병입원의료비', '*common*'),
	('1705', '17', '질병통원의료비', '*common*'),
	('1706', '17', '교통상해입원의료비', '*common*'),
	('1707', '17', '입원의료비(80%)', '*common*'),
	('1708', '17', '통원의료비(80%)', '*common*'),
	('1709', '17', '상해입원의료비(90%)', '*common*'),
	('1710', '17', '질병입원의료비(90%)', '*common*'),
	('1711', '17', '(신)종합입원의료비(90%)', '*common*'),
	('1712', '17', '(신)종합입원의료비', '*common*'),
	('1713', '17', '(신)종합통원의료비', '*common*'),
	('1714', '17', '일상생활중배상책임', '*common*'),
	('1715', '17', '가족일상생활중배상책임', '*common*'),
	('1716', '17', '자녀일상생활중배상책임', '*common*'),
	('1801', '18', '벌금', '*common*'),
	('1802', '18', '방어비용', '*common*'),
	('1803', '18', '면허정지위로금', '*common*'),
	('1804', '18', '면허취소위로금', '*common*'),
	('1805', '18', '생활안정지원금', '*common*'),
	('1806', '18', '형사합의지원금', '*common*'),
	('1807', '18', '타인사망시형사합의지원금', '*common*'),
	('1808', '18', '부상시형사합의지원금', '*common*'),
	('1809', '18', '긴급비용', '*common*'),
	('1810', '18', '교통사고처리비용', '*common*'),
	('1811', '18', '자동차보험료할증지원금', '*common*'),
	('1812', '18', '주차장및아파트단지내사고지원금', '*common*'),
	('1813', '18', '자차전손위로금', '*common*'),
	('1814', '18', '자차부분손해위로금', '*common*'),
	('1901', '19', '말기신부전증', '*common*'),
	('1902', '19', '중대한화상', '*common*'),
	('1903', '19', '재생불량성빈혈', '*common*'),
	('1904', '19', '양성뇌종양', '*common*'),
	('1905', '19', '재해로인한 뇌손상, 내장손상 수술', '*common*'),
	('1906', '19', '중대한질병', '*common*'),
	('1907', '19', '중대한수술', '*common*'),
	('1908', '19', '재해로인한추상', '*common*'),
	('1909', '19', 'CI', '*common*'),
	('2001', '20', '골프배상책임', '*common*'),
	('2002', '20', '골프중상해사망후유장애', '*common*'),
	('2003', '20', '홀인원축하금', '*common*'),
	('2004', '20', '골프용품손해위로금', '*common*'),
	('2005', '20', '강력범죄위로금', '*common*'),
	('2006', '20', '식중독위로금', '*common*'),
	('2007', '20', '유방절제수술위로금', '*common*'),
	('2008', '20', '통원급여금', '*common*'),
	('2009', '20', '생존급여금', '*common*'),
	('2010', '20', '만기환급금', '*common*'),
	('2011', '20', '만기축하금', '*common*'),
	('2012', '20', '건강축하금', '*common*'),
	('2013', '20', '유족연금', '*common*'),
	('2014', '20', '자동차사고부상위로금', '*common*'),
	('2101', '21', '선천이상수술비', '*common*'),
	('2102', '21', '선천이상입원비', '*common*'),
	('2103', '21', '저체중아보육비', '*common*'),
	('2104', '21', '주산기질환입원비', '*common*'),
	('2105', '21', '어린이(청소년)주요질환수술비', '*common*'),
	('2106', '21', '컴퓨터관련질환수술비', '*common*'),
	('2107', '21', '자녀안심보험금', '*common*'),
	('2108', '21', '특정전염병위로금', '*common*');
/*!40000 ALTER TABLE `t_fin_dambo` ENABLE KEYS */;

-- 테이블 explan_new.t_fin_dambo_group 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_fin_dambo_group` (
  `DAMBO_NUM` varchar(14) NOT NULL,
  `GROUP_NUM` varchar(14) NOT NULL,
  `USER_ID` varchar(20) NOT NULL,
  `PIVOT_VALUE` int(11) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`,`GROUP_NUM`,`DAMBO_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_fin_dambo_group:~49 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_fin_dambo_group` DISABLE KEYS */;
INSERT INTO `t_fin_dambo_group` (`DAMBO_NUM`, `GROUP_NUM`, `USER_ID`, `PIVOT_VALUE`) VALUES
	('1101', '15002d6bf4233a', 'jonsaram', NULL),
	('1201', '15002e2d1a819b', 'jonsaram', NULL),
	('1202', '15002e2d1a819b', 'jonsaram', NULL),
	('1101', '150275a19fbc20', 'jonsaram', NULL),
	('1102', '150275a19fbc20', 'jonsaram', NULL),
	('1103', '150275a19fbc20', 'jonsaram', NULL),
	('1104', '150275a19fbc20', 'jonsaram', NULL),
	('1105', '150275a19fbc20', 'jonsaram', NULL),
	('1106', '150275a19fbc20', 'jonsaram', NULL),
	('1107', '150275a19fbc20', 'jonsaram', NULL),
	('1201', '150275a19fbc20', 'jonsaram', NULL),
	('1202', '150275a19fbc20', 'jonsaram', NULL),
	('1203', '150275a19fbc20', 'jonsaram', NULL),
	('1204', '150275a19fbc20', 'jonsaram', NULL),
	('1205', '150275a19fbc20', 'jonsaram', NULL),
	('1206', '150275a19fbc20', 'jonsaram', NULL),
	('1207', '150275a19fbc20', 'jonsaram', NULL),
	('1208', '150275a19fbc20', 'jonsaram', NULL),
	('1301', '150275a19fbc20', 'jonsaram', NULL),
	('1317', '150275a19fbc20', 'jonsaram', NULL),
	('1318', '150275a19fbc20', 'jonsaram', NULL),
	('1402', '150275a19fbc20', 'jonsaram', NULL),
	('1403', '150275a19fbc20', 'jonsaram', NULL),
	('1405', '150275a19fbc20', 'jonsaram', NULL),
	('1414', '150275a19fbc20', 'jonsaram', NULL),
	('1415', '150275a19fbc20', 'jonsaram', NULL),
	('1601', '150275a19fbc20', 'jonsaram', NULL),
	('1602', '150275a19fbc20', 'jonsaram', NULL),
	('1603', '150275a19fbc20', 'jonsaram', NULL),
	('1604', '150275a19fbc20', 'jonsaram', NULL),
	('1605', '150275a19fbc20', 'jonsaram', NULL),
	('1610', '150275a19fbc20', 'jonsaram', NULL),
	('1625', '150275a19fbc20', 'jonsaram', NULL),
	('1905', '150275a19fbc20', 'jonsaram', NULL),
	('1908', '150275a19fbc20', 'jonsaram', NULL),
	('1101', '15093557408336', 'jonsaram', 10000),
	('1301', '15093557408336', 'jonsaram', 5000),
	('1312', '15093557408336', 'jonsaram', 5000),
	('1315', '15093557408336', 'jonsaram', 5000),
	('1702', '15093557408336', 'jonsaram', 10000),
	('1703', '15093557408336', 'jonsaram', 30),
	('1704', '15093557408336', 'jonsaram', 10000),
	('1705', '15093557408336', 'jonsaram', 30),
	('1101', '1509cc5f36112b', 'jonsaram', NULL),
	('1201', '1509cc5f36112b', 'jonsaram', NULL),
	('1101', '159b5cc1eff198', 'jonsaram', NULL),
	('1102', '159b5cc1eff198', 'jonsaram', NULL),
	('1103', '159b5cc1eff198', 'jonsaram', NULL),
	('1104', '159b5cc1eff198', 'jonsaram', NULL);
/*!40000 ALTER TABLE `t_fin_dambo_group` ENABLE KEYS */;

-- 테이블 explan_new.t_fin_dambo_group_info 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_fin_dambo_group_info` (
  `USER_ID` varchar(20) NOT NULL,
  `GROUP_NUM` varchar(14) NOT NULL,
  `GROUP_NAME` varchar(50) DEFAULT NULL,
  `BASE_CHECK` varchar(1) DEFAULT NULL,
  `CHART_CHECK` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`,`GROUP_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_fin_dambo_group_info:~3 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_fin_dambo_group_info` DISABLE KEYS */;
INSERT INTO `t_fin_dambo_group_info` (`USER_ID`, `GROUP_NUM`, `GROUP_NAME`, `BASE_CHECK`, `CHART_CHECK`) VALUES
	('jonsaram', '150275a19fbc20', '기본 담보 그룹', '1', '0'),
	('jonsaram', '15093557408336', 'Chart 담보 그룹', '0', '1'),
	('jonsaram', '1509cc5f36112b', 'Test 담보 그룹', '0', '0');
/*!40000 ALTER TABLE `t_fin_dambo_group_info` ENABLE KEYS */;

-- 테이블 explan_new.t_fin_immovable 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_fin_immovable` (
  `IMMOVABLE_NUM` varchar(14) NOT NULL,
  `IMMOVABLE_TYPE` varchar(20) NOT NULL,
  `IMMOVABLE_NAME` varchar(50) DEFAULT NULL,
  `IMMOVABLE_VALUE` int(11) DEFAULT NULL,
  `INFLATION_RATE` float DEFAULT NULL,
  `LOCATION` varchar(100) DEFAULT NULL,
  `COMMENT` mediumtext,
  `START_DATE` varchar(8) DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  `DEL_YN` char(1) DEFAULT 'N',
  `DEL_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`IMMOVABLE_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_fin_immovable:~6 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_fin_immovable` DISABLE KEYS */;
INSERT INTO `t_fin_immovable` (`IMMOVABLE_NUM`, `IMMOVABLE_TYPE`, `IMMOVABLE_NAME`, `IMMOVABLE_VALUE`, `INFLATION_RATE`, `LOCATION`, `COMMENT`, `START_DATE`, `CREATE_DATE`, `DEL_YN`, `DEL_DATE`) VALUES
	('15a184fa5902dc', '', 'wes', NULL, NULL, NULL, NULL, NULL, '2017-02-07 20:22:37', 'Y', '2017-02-07 20:22:59'),
	('15a184ffbbf109', '', '11', 11, 11, '', '', NULL, '2017-02-07 20:22:59', 'Y', '2017-02-08 15:21:16'),
	('15a184ffbc0314', '', '2wes', NULL, NULL, NULL, NULL, NULL, '2017-02-07 20:22:59', 'Y', '2017-02-08 15:21:16'),
	('15a1c629364378', '주택', '영통 힐스테이트 아파트', 46000, 1, '', '', '20100505', '2017-02-08 15:21:46', 'N', NULL),
	('15a1c63e2a3188', '', '자산종류 자산종류 자산종류 자산종류 자산종류', 22, 33, '44', '', NULL, '2017-02-08 15:23:12', 'Y', '2017-02-08 18:02:02'),
	('15a454dac462b4', '상가', '힐스 앞 상가', 20000, 2, '', '', '20100505', '2017-02-16 14:03:22', 'N', NULL);
/*!40000 ALTER TABLE `t_fin_immovable` ENABLE KEYS */;

-- 테이블 explan_new.t_fin_insurance 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_fin_insurance` (
  `INSURANCE_NUM` varchar(14) NOT NULL,
  `INSURANCE_TYPE` varchar(20) NOT NULL,
  `COMPANY_NAME` varchar(30) DEFAULT NULL,
  `TITLE` varchar(50) NOT NULL,
  `CONTRACTOR` varchar(20) NOT NULL,
  `PAY_EACH_MONTH` int(11) NOT NULL,
  `START_DATE` varchar(10) NOT NULL,
  `GUARANTEE_TERM` tinyint(4) NOT NULL,
  `GUARANTEE_TERM_TYPE` varchar(10) NOT NULL,
  `PAY_TERM` tinyint(4) DEFAULT NULL,
  `PAY_TERM_TYPE` varchar(10) NOT NULL,
  `COMMENT` text,
  `STATE` varchar(12) DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  `DEL_YN` varchar(1) NOT NULL DEFAULT 'N',
  `DEL_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`INSURANCE_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_fin_insurance:~12 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_fin_insurance` DISABLE KEYS */;
INSERT INTO `t_fin_insurance` (`INSURANCE_NUM`, `INSURANCE_TYPE`, `COMPANY_NAME`, `TITLE`, `CONTRACTOR`, `PAY_EACH_MONTH`, `START_DATE`, `GUARANTEE_TERM`, `GUARANTEE_TERM_TYPE`, `PAY_TERM`, `PAY_TERM_TYPE`, `COMMENT`, `STATE`, `CREATE_DATE`, `DEL_YN`, `DEL_DATE`) VALUES
	('14f68cddcfb10a', '종신보험', 'A보험사', '조은보험', '위성열', 50000, '20140505', 100, '년만기', 20, '년납', NULL, NULL, '2015-08-26 15:59:29', 'N', NULL),
	('14f68cf179f32b', '종신보험', 'A보험사', '조은보험', '위성열', 50000, '20140505', 100, '년만기', 20, '년납', NULL, NULL, '2015-08-26 16:00:49', 'N', NULL),
	('14f68d18c68132', '종신보험', 'A보험사', '조은보험', '위성열', 50000, '2015-09-01', 100, '세만기', 60, '세납', NULL, NULL, '2015-08-26 16:03:27', 'N', NULL),
	('14f921ba92f182', '건강보험', 'B보험사', '나쁜보험', '위성열', 150000, '2014-06-05', 80, '세만기', 20, '년납', NULL, NULL, '2015-09-03 16:28:50', 'N', NULL),
	('150640c980a550', '종신보험', 'B보험사', '나쁜보험', '위성열', 150000, '2014-06-05', 100, '세만기', 20, '년납', NULL, NULL, '2015-10-14 10:52:38', 'N', NULL),
	('1508d42776b3c0', '종신보험', 'B보험사', '나쁜보험', '위성열', 150000, '2014-06-05', 100, '세만기', 20, '년납', NULL, NULL, '2015-10-22 10:55:54', 'N', NULL),
	('159aaef02e0249', '건강보험', 'B보험사', '나쁜보험', '위성열', 150000, '2014-06-05', 100, '세만기', 20, '년납', NULL, NULL, '2017-01-17 14:38:27', 'N', NULL),
	('159cfeb2befb00', '종신보험', 'C보험사', '그냥보험', '위성열', 130000, '2014-06-05', 100, '세만기', 20, '년납', NULL, NULL, '2017-01-24 19:00:13', 'N', NULL),
	('159d00bf516150', '종신보험', 'A보험사', '조은보험', '위성열', 50000, '2015-09-01', 100, '세만기', 60, '세납', NULL, NULL, '2017-01-24 19:36:01', 'Y', NULL),
	('15a1873ebbc231', '종신보험', 'A보험사', '조은보험', '위성열', 50000, '20150901', 100, '세만기', 60, '세납', NULL, NULL, '2017-02-07 21:02:14', 'N', NULL),
	('15a1873ebbf26f', '건강보험', 'B보험사', '나쁜보험', '위성열', 150000, '20140605', 80, '세만기', 20, '년납', NULL, NULL, '2017-02-07 21:02:14', 'N', NULL),
	('15a18745f17148', '종신보험', 'B보험사', '나쁜보험', '위성열', 150000, '20140605', 100, '세만기', 20, '년납', NULL, NULL, '2017-02-07 21:02:44', 'N', NULL);
/*!40000 ALTER TABLE `t_fin_insurance` ENABLE KEYS */;

-- 테이블 explan_new.t_fin_insurance_dambo 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_fin_insurance_dambo` (
  `INSURANCE_NUM` varchar(14) NOT NULL,
  `INSURED_NUM` tinyint(4) NOT NULL,
  `INSURANCE_DAMBO_NUM` varchar(14) NOT NULL DEFAULT '0',
  `INSURANCE_MONEY` varchar(100) DEFAULT NULL,
  `DAMBO_NUM` varchar(14) DEFAULT NULL,
  `VALIDITY` char(1) DEFAULT NULL,
  `ORDER_INDEX` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`INSURANCE_DAMBO_NUM`,`INSURANCE_NUM`,`INSURED_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_fin_insurance_dambo:~27 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_fin_insurance_dambo` DISABLE KEYS */;
INSERT INTO `t_fin_insurance_dambo` (`INSURANCE_NUM`, `INSURED_NUM`, `INSURANCE_DAMBO_NUM`, `INSURANCE_MONEY`, `DAMBO_NUM`, `VALIDITY`, `ORDER_INDEX`) VALUES
	('159aaef02e0249', 1, '159aaf095b92c9', '80/4000~6000,100/2000', '1101', 'Y', NULL),
	('159aaef02e0249', 1, '159aaf095c92fc', '100/1', '1103', 'Y', NULL),
	('14f921ba92f182', 1, '159aaf19557810', '100/10000', '1101', 'Y', NULL),
	('14f921ba92f182', 1, '159aaf195669e0', '100/3000', '1301', 'Y', NULL),
	('14f68d18c68132', 1, '159cabb639813c', '80/1000~2000,100/2000', '1101', 'Y', NULL),
	('14f68d18c68132', 1, '159cabb639817c', '100/8000', '1312', 'Y', NULL),
	('14f68d18c68132', 1, '159cabb6398185', '100/30', '1703', 'Y', NULL),
	('14f68d18c68132', 1, '159cabb6398273', '100/5000', '1702', 'Y', NULL),
	('14f68d18c68132', 1, '159cabb63982b0', '100/3000', '1103', 'Y', NULL),
	('14f68d18c68132', 1, '159cabb6398430', '66/5000', '1704', 'Y', NULL),
	('14f68d18c68132', 1, '159cabb63a731a', '100/3000', '2106', 'Y', NULL),
	('14f68d18c68132', 1, '159cabb63a73c3', '100/30', '1705', 'Y', NULL),
	('14f68d18c68132', 1, '159cabb63a73fd', '88/99', '2104', 'Y', NULL),
	('14f68d18c68132', 2, '159cabcde6414e', '100/5000', '1101', 'Y', NULL),
	('159d00bf516150', 2, '159cabcde6414e', '100/5000', '1101', 'Y', NULL),
	('14f68d18c68132', 2, '159cabcde7322b', '100/5000', '1301', 'Y', NULL),
	('159d00bf516150', 2, '159cabcde7322b', '100/5000', '1301', 'Y', NULL),
	('14f68d18c68132', 2, '159cabcde7329a', '100/5000', '1311', 'Y', NULL),
	('159d00bf516150', 2, '159cabcde7329a', '100/5000', '1311', 'Y', NULL),
	('14f68d18c68132', 3, '159cf0742fbec0', '100/3000', '1101', 'Y', NULL),
	('159d00bf516150', 3, '159cf0742fbec0', '100/3000', '1101', 'Y', NULL),
	('159d00bf516150', 1, '159d00c874216e', '100/30', '1703', 'Y', NULL),
	('159d00bf516150', 1, '159d00c8742c00', '80/1000~2000,100/2000', '1101', 'Y', NULL),
	('159d00bf516150', 1, '159d00c874c1dc', '66/5000', '1704', 'Y', NULL),
	('159d00bf516150', 1, '159d00c874c25d', '100/30', '1705', 'Y', NULL),
	('159d00bf516150', 1, '159d00c874c29e', '100/3000', '2106', 'Y', NULL),
	('159d00bf516150', 1, '159d00c874c9c0', '88/99', '2104', 'Y', NULL);
/*!40000 ALTER TABLE `t_fin_insurance_dambo` ENABLE KEYS */;

-- 테이블 explan_new.t_fin_insured 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_fin_insured` (
  `INSURANCE_NUM` varchar(14) NOT NULL,
  `INSURED_NUM` tinyint(4) NOT NULL,
  `INSURED_NAME` char(18) DEFAULT NULL,
  `INSURED_BIRTH_YEAR` char(18) DEFAULT NULL,
  PRIMARY KEY (`INSURANCE_NUM`,`INSURED_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_fin_insured:~19 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_fin_insured` DISABLE KEYS */;
INSERT INTO `t_fin_insured` (`INSURANCE_NUM`, `INSURED_NUM`, `INSURED_NAME`, `INSURED_BIRTH_YEAR`) VALUES
	('14f68d18c68132', 1, '위성열', '1974'),
	('14f68d18c68132', 2, '위소윤', '2015'),
	('14f68d18c68132', 3, '문공주', '1975'),
	('14f921ba92f182', 1, '위성열', '1974'),
	('150640c980a550', 1, '문공주', '1979'),
	('1508d42776b3c0', 1, '문공주', '1979'),
	('159aaef02e0249', 1, '위성열', '1974'),
	('159cfae01b038a', 1, '위성열', '1974'),
	('159cfd089232c0', 1, '위성열', '1974'),
	('159cfeb2befb00', 1, '위성열', '1974'),
	('159cfff883f2aa', 1, '위성열', '1974'),
	('159cfff883f2aa', 2, '위소윤', '2015'),
	('159cfff883f2aa', 3, '문공주', '1975'),
	('159d00bf516150', 1, '위성열', '1974'),
	('159d00bf516150', 2, '위소윤', '2015'),
	('159d00bf516150', 3, '문공주', '1975'),
	('15a1873ebbc231', 1, '위성열', '1974'),
	('15a1873ebbc231', 2, '위소윤', '2015'),
	('15a1873ebbc231', 3, '문공주', '1975'),
	('15a1873ebbf26f', 1, '위성열', '1974'),
	('15a18745f17148', 1, '문공주', '1979');
/*!40000 ALTER TABLE `t_fin_insured` ENABLE KEYS */;

-- 테이블 explan_new.t_fin_investment 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_fin_investment` (
  `INVESTMENT_NUM` varchar(14) NOT NULL,
  `INVESTMENT_TYPE` varchar(20) DEFAULT NULL,
  `INVESTMENT_TITLE` varchar(50) DEFAULT NULL,
  `START_DATE` varchar(8) DEFAULT NULL,
  `END_TERM` varchar(8) DEFAULT NULL,
  `INTEREST_RATE` varchar(8) DEFAULT NULL,
  `INTEREST_TYPE` varchar(6) DEFAULT NULL,
  `TAX` varchar(8) DEFAULT NULL,
  `TERM` varchar(8) DEFAULT NULL,
  `REGULAR_MONEY` varchar(10) DEFAULT NULL,
  `BASE_MONEY` varchar(12) DEFAULT NULL,
  `COMMENT` mediumtext,
  `CREATE_DATE` datetime DEFAULT NULL,
  `STATE` varchar(12) DEFAULT NULL,
  `DEL_YN` varchar(1) DEFAULT 'N',
  `DEL_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`INVESTMENT_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_fin_investment:~16 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_fin_investment` DISABLE KEYS */;
INSERT INTO `t_fin_investment` (`INVESTMENT_NUM`, `INVESTMENT_TYPE`, `INVESTMENT_TITLE`, `START_DATE`, `END_TERM`, `INTEREST_RATE`, `INTEREST_TYPE`, `TAX`, `TERM`, `REGULAR_MONEY`, `BASE_MONEY`, `COMMENT`, `CREATE_DATE`, `STATE`, `DEL_YN`, `DEL_DATE`) VALUES
	('15a17fc6fd324d', '적금', '적금', '20160505', '', '10', '단리', '1.4', '24', '100000', '', NULL, '2017-02-07 18:51:44', NULL, 'N', NULL),
	('15a17fc6fda2b3', '적금', '적금', '20160505', '', '10', '단리', '1.4', '24', '100000', '', NULL, '2017-02-07 18:51:44', NULL, 'N', NULL),
	('15a17fc6fdb189', '예금', '예금', '20160505', '24', '10', '연복리', '15.4', '', '', '500000', NULL, '2017-02-07 18:51:44', NULL, 'N', NULL),
	('15a17fd19921ea', '적금', '적금', '20160505', '', '10', '단리', '1.4', '24', '100000', '', NULL, '2017-02-07 18:52:27', NULL, 'N', NULL),
	('15a1803f44d25e', '적금', '적금', '20160505', '', '10', '단리', '1.4', '24', '100000', '', NULL, '2017-02-07 18:59:56', NULL, 'N', NULL),
	('15a1803f453db0', '적금', '적금', '20160505', '', '10', '단리', '1.4', '24', '100000', '', NULL, '2017-02-07 18:59:56', NULL, 'N', NULL),
	('15a1803f455a60', '예금', '예금', '20160505', '24', '10', '연복리', '15.4', '', '', '500000', NULL, '2017-02-07 18:59:56', NULL, 'N', NULL),
	('15a180ea9c115d', '적금', '적금', '20160505', '', '10', '단리', '1.4', '24', '100000', '', NULL, '2017-02-07 19:11:38', NULL, 'N', NULL),
	('15a180ea9c33ac', '적금', '적금', '20160505', '', '10', '단리', '1.4', '24', '100000', '', NULL, '2017-02-07 19:11:38', NULL, 'N', NULL),
	('15a180ea9c5274', '예금', '예금', '20160505', '24', '10', '연복리', '15.4', '', '', '500000', NULL, '2017-02-07 19:11:38', NULL, 'N', NULL),
	('15a186722ba23e', '예금', '예금', '20160505', '24', '10', '연복리', '15.4', '', '', '500000', NULL, '2017-02-07 20:48:16', NULL, 'Y', '2017-02-07 20:50:17'),
	('15a186722be1de', '적금', '적금', '20160505', '', '10', '단리', '1.4', '24', '100000', '', NULL, '2017-02-07 20:48:16', NULL, 'Y', '2017-02-07 20:50:17'),
	('15a18688f881c3', '펀드', '펀드', '20160505', '23', '10', NULL, NULL, '24', '100000', '100000', NULL, '2017-02-07 20:49:50', NULL, 'Y', '2017-02-07 20:50:17'),
	('15a1868b093c20', '펀드', '1펀드', '20160505', '23', '10', NULL, NULL, '24', '100000', '100000', NULL, '2017-02-07 20:49:58', NULL, 'Y', '2017-02-09 16:55:20'),
	('15a21dbc236226', '펀드', '1펀드', '20160505', '23', '10', '월복리', NULL, '24', '100000', '100000', NULL, '2017-02-09 16:52:14', NULL, 'N', NULL),
	('15a21de96bc300', '보험', '보험', '20160505', '420', '3', '월복리', NULL, '120', '100000', '0', NULL, '2017-02-09 16:55:20', NULL, 'N', NULL),
	('15aea03d5f829b', '기타', '기타', '20160505', '420', '3', '월복리', NULL, '120', '100000', '0', NULL, '2017-03-20 13:40:04', NULL, 'N', NULL),
	('15aea28ed73335', '주식', '주식', '20160505', '23', '10', '월복리', NULL, '24', '100000', '100000', NULL, '2017-03-20 14:20:35', NULL, 'N', NULL);
/*!40000 ALTER TABLE `t_fin_investment` ENABLE KEYS */;

-- 테이블 explan_new.t_fin_investment_subdata 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_fin_investment_subdata` (
  `INVESTMENT_NUM` varchar(14) NOT NULL,
  `PRE_FEE` varchar(4) DEFAULT NULL,
  `AFTER_PRE_FEE` varchar(4) DEFAULT NULL,
  `PRE_FEE2` varchar(4) DEFAULT NULL,
  `NORMAL_FEE` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`INVESTMENT_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_fin_investment_subdata:~6 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_fin_investment_subdata` DISABLE KEYS */;
INSERT INTO `t_fin_investment_subdata` (`INVESTMENT_NUM`, `PRE_FEE`, `AFTER_PRE_FEE`, `PRE_FEE2`, `NORMAL_FEE`) VALUES
	('15a0d6b3ffa14a', NULL, NULL, NULL, '1.5'),
	('15a12631eb0140', '13', '', '', '1'),
	('15a18688f881c3', NULL, NULL, NULL, '11'),
	('15a1868b093c20', NULL, NULL, NULL, '11'),
	('15a21dbc236226', NULL, NULL, NULL, '1'),
	('15a21de96bc300', '7', '10', '3.5', '1');
/*!40000 ALTER TABLE `t_fin_investment_subdata` ENABLE KEYS */;

-- 테이블 explan_new.t_fin_loan 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_fin_loan` (
  `LOAN_NUM` varchar(14) NOT NULL,
  `LOAN_TYPE` varchar(30) NOT NULL,
  `LOAN_COMPANY` varchar(50) DEFAULT NULL,
  `LOAN_TOTAL` int(11) DEFAULT NULL,
  `LOAN_RATE` float DEFAULT NULL,
  `START_DATE` varchar(8) DEFAULT NULL,
  `KUCHI_TERM` int(11) DEFAULT NULL,
  `PAYBACK_TERM` int(11) DEFAULT NULL,
  `PAYBACK_TYPE` varchar(18) DEFAULT NULL,
  `PAYBACK_EACH_MONTH` int(11) DEFAULT NULL,
  `COMMENT` text,
  `CREATE_DATE` datetime DEFAULT NULL,
  `DEL_YN` char(1) DEFAULT 'N',
  `DEL_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`LOAN_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 테이블 데이터 explan_new.t_fin_loan:~8 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_fin_loan` DISABLE KEYS */;
INSERT INTO `t_fin_loan` (`LOAN_NUM`, `LOAN_TYPE`, `LOAN_COMPANY`, `LOAN_TOTAL`, `LOAN_RATE`, `START_DATE`, `KUCHI_TERM`, `PAYBACK_TERM`, `PAYBACK_TYPE`, `PAYBACK_EACH_MONTH`, `COMMENT`, `CREATE_DATE`, `DEL_YN`, `DEL_DATE`) VALUES
	('15a1d476767331', '3', '2', 2, 2, '1', 2, 0, '1', 2, '2', '2017-02-08 19:31:43', 'Y', '2017-02-08 19:35:42'),
	('15a1d4ada77214', '1', '2', 2, 2, '1', 2, 0, '1', 2, '2', '2017-02-08 19:35:29', 'Y', '2017-02-08 19:36:48'),
	('15a1d4bd7dc218', '1', '2', 2, 2, '1', 2, 0, '1', 2, '2', '2017-02-08 19:36:34', 'Y', '2017-02-08 19:38:18'),
	('15a1d4bd7dd3be', '1', '2', 2, 2, '1', 2, 0, '1', 2, '2', '2017-02-08 19:36:34', 'Y', '2017-02-08 19:38:18'),
	('15a1d4c0e9e318', '1', '2', 2, 2, '1', 2, 0, '1', 2, '2', '2017-02-08 19:36:48', 'Y', '2017-02-08 19:38:18'),
	('15a22e01d213ff', '주택담보대출', '우리', 10000, 10, '20170101', 12, NULL, '만기일시상환', 833333, '1111', '2017-02-09 21:36:37', 'Y', '2017-02-10 18:54:36'),
	('15a25c6bc902e1', '신용대출', '국민', 10000, 10, '20150101', NULL, 24, '원리금균등상환', 4614493, '1111', '2017-02-10 11:07:45', 'Y', '2017-02-10 17:51:01'),
	('15a2762eedf3df', '주택담보대출', '우리', 10000, 10, '20170101', NULL, 12, '원리금균등상환', 8791589, '1111', '2017-02-10 18:37:59', 'N', NULL),
	('15a3b9f9e7c14c', '신용대출', '우리', 20000, 10, '20170101', 12, 120, '원리금균등상환', 1666667, '1111', '2017-02-14 16:56:40', 'N', NULL);
/*!40000 ALTER TABLE `t_fin_loan` ENABLE KEYS */;

-- 뷰 explan_new.v_com_customer 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `v_com_customer` (
	`CUSTOMER_NUM` VARCHAR(14) NOT NULL COLLATE 'utf8_general_ci',
	`CUSTOMER_NAME` VARCHAR(20) NULL COLLATE 'utf8_general_ci',
	`BIRTHDAY` VARCHAR(8) NULL COLLATE 'utf8_general_ci',
	`USER_ID` VARCHAR(20) NULL COLLATE 'utf8_general_ci',
	`PHONE_NUM` VARCHAR(14) NULL COLLATE 'utf8_general_ci',
	`EMAIL` VARCHAR(50) NULL COLLATE 'utf8_general_ci',
	`CREATE_DATE` DATETIME NULL,
	`DEL_YN` VARCHAR(1) NULL COLLATE 'utf8_general_ci',
	`DEL_DATE` DATETIME NULL
) ENGINE=MyISAM;

-- 뷰 explan_new.v_com_plan 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `v_com_plan` (
	`PLAN_NUM` VARCHAR(14) NOT NULL COLLATE 'utf8_general_ci',
	`VERSION_SEQ` VARCHAR(2) NULL COLLATE 'utf8_general_ci',
	`CUSTOMER_NUM` VARCHAR(14) NULL COLLATE 'utf8_general_ci',
	`PLAN_NAME` VARCHAR(50) NULL COLLATE 'utf8_general_ci',
	`CREATE_DATE` DATETIME NULL,
	`START_DATE` VARCHAR(8) NULL COLLATE 'utf8_general_ci',
	`USE_YN` VARCHAR(1) NULL COLLATE 'utf8_general_ci',
	`DEL_YN` VARCHAR(1) NULL COLLATE 'utf8_general_ci',
	`PLAN_TYPE` VARCHAR(4) NOT NULL COLLATE 'utf8_general_ci',
	`BASE_PLAN_NUM` VARCHAR(14) NULL COLLATE 'utf8_general_ci',
	`BASE_PLAN_NAME` VARCHAR(50) NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

-- 뷰 explan_new.v_com_customer 구조 내보내기
-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `v_com_customer`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_com_customer` AS select `t_com_customer`.`CUSTOMER_NUM` AS `CUSTOMER_NUM`,`t_com_customer`.`CUSTOMER_NAME` AS `CUSTOMER_NAME`,`t_com_customer`.`BIRTHDAY` AS `BIRTHDAY`,`t_com_customer`.`USER_ID` AS `USER_ID`,`t_com_customer`.`PHONE_NUM` AS `PHONE_NUM`,`t_com_customer`.`EMAIL` AS `EMAIL`,`t_com_customer`.`CREATE_DATE` AS `CREATE_DATE`,`t_com_customer`.`DEL_YN` AS `DEL_YN`,`t_com_customer`.`DEL_DATE` AS `DEL_DATE` from `t_com_customer` where (`t_com_customer`.`DEL_YN` = 'N') ;

-- 뷰 explan_new.v_com_plan 구조 내보내기
-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `v_com_plan`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_com_plan` AS SELECT PLAN_NUM      AS PLAN_NUM, 
       VERSION_SEQ   AS VERSION_SEQ, 
       CUSTOMER_NUM  AS CUSTOMER_NUM, 
       PLAN_NAME     AS PLAN_NAME, 
       CREATE_DATE   AS CREATE_DATE, 
       START_DATE    AS START_DATE, 
       USE_YN        AS USE_YN, 
       DEL_YN        AS DEL_YN, 
       PLAN_TYPE     AS PLAN_TYPE, 
       BASE_PLAN_NUM AS BASE_PLAN_NUM ,
       (SELECT PLAN_NAME FROM T_COM_PLAN CP2 WHERE T_COM_PLAN.BASE_PLAN_NUM = CP2.PLAN_NUM) AS BASE_PLAN_NAME
FROM   T_COM_PLAN 
WHERE  
		USE_YN = 'Y'  
	AND DEL_YN = 'N' ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
