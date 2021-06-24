-- --------------------------------------------------------
-- ȣ��Ʈ:                          127.0.0.1
-- ���� ����:                        10.1.20-MariaDB - mariadb.org binary distribution
-- ���� OS:                        Win64
-- HeidiSQL ����:                  9.4.0.5144
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- �Լ� explan_new.makeUniqueID ���� ��������
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `makeUniqueID`() RETURNS varchar(14) CHARSET utf8
    DETERMINISTIC
RETURN CONCAT(SUBSTRING((HEX(NOW() - 0)), 3, 10), SUBSTRING((FLOOR(RAND() * 10000) + 1000), 1, 4))//
DELIMITER ;

-- ���̺� explan_new.t_com_code ���� ��������
CREATE TABLE IF NOT EXISTS `t_com_code` (
  `CODE_NUM` varchar(14) NOT NULL,
  `CODE_GROUP_NUM` varchar(14) DEFAULT NULL,
  `CODE_NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CODE_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_com_code:~0 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_com_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_com_code` ENABLE KEYS */;

-- ���̺� explan_new.t_com_code_group ���� ��������
CREATE TABLE IF NOT EXISTS `t_com_code_group` (
  `CODE_GROUP_NUM` varchar(14) NOT NULL,
  `GROUP_NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CODE_GROUP_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_com_code_group:~0 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_com_code_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_com_code_group` ENABLE KEYS */;

-- ���̺� explan_new.t_com_common_code ���� ��������
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

-- ���̺� ������ explan_new.t_com_common_code:~58 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_com_common_code` DISABLE KEYS */;
INSERT INTO `t_com_common_code` (`COMMON_TCD`, `COMMON_CODE`, `COMMON_NAME`, `ATTB1`, `ATTB2`, `ATTB3`, `ORDER_SEQ`) VALUES
	('GUARANTEE_TERM_TYPE', '�⸸��', '�⸸��', NULL, NULL, NULL, 2),
	('GUARANTEE_TERM_TYPE', '������', '������', NULL, NULL, NULL, 1),
	('IMMOVABLE_TYPE', '��Ÿ', '��Ÿ', NULL, NULL, NULL, 6),
	('IMMOVABLE_TYPE', '��', '��', NULL, NULL, NULL, 2),
	('IMMOVABLE_TYPE', '���ǽ���', '���ǽ���', NULL, NULL, NULL, 3),
	('IMMOVABLE_TYPE', '�ڵ���', '�ڵ���', NULL, NULL, NULL, 5),
	('IMMOVABLE_TYPE', '����', '����', NULL, NULL, NULL, 1),
	('IMMOVABLE_TYPE', '����', '����', NULL, NULL, NULL, 4),
	('INSURANCE_TYPE', '�ǰ�����', '�ǰ�����', NULL, NULL, NULL, 2),
	('INSURANCE_TYPE', '����', '����', NULL, NULL, NULL, 18),
	('INSURANCE_TYPE', '��Ÿ', '��Ÿ', NULL, NULL, NULL, 20),
	('INSURANCE_TYPE', '��', '��', NULL, NULL, NULL, 19),
	('INSURANCE_TYPE', '��ī������', '��ī������', NULL, NULL, NULL, 11),
	('INSURANCE_TYPE', '���׺���Ư��', '���׺���Ư��', NULL, NULL, NULL, 17),
	('INSURANCE_TYPE', '���غ���', '���غ���', NULL, NULL, NULL, 6),
	('INSURANCE_TYPE', '���غ���', '���غ���', NULL, NULL, NULL, 9),
	('INSURANCE_TYPE', '�Ǽպ���', '�Ǽպ���', NULL, NULL, NULL, 10),
	('INSURANCE_TYPE', '�Ϻ���', '�Ϻ���', NULL, NULL, NULL, 5),
	('INSURANCE_TYPE', '��̺���', '��̺���', NULL, NULL, NULL, 12),
	('INSURANCE_TYPE', '���ݺ���Ư��', '���ݺ���Ư��', NULL, NULL, NULL, 16),
	('INSURANCE_TYPE', '�����ں���', '�����ں���', NULL, NULL, NULL, 14),
	('INSURANCE_TYPE', '�Ƿ����', '�Ƿ����', NULL, NULL, NULL, 4),
	('INSURANCE_TYPE', '��⺸��', '��⺸��', NULL, NULL, NULL, 7),
	('INSURANCE_TYPE', '���ຸ��Ư��', '���ຸ��Ư��', NULL, NULL, NULL, 15),
	('INSURANCE_TYPE', '���⺸��', '���⺸��', NULL, NULL, NULL, 3),
	('INSURANCE_TYPE', '���ź���', '���ź���', NULL, NULL, NULL, 1),
	('INSURANCE_TYPE', '�¾ƺ���', '�¾ƺ���', NULL, NULL, NULL, 13),
	('INSURANCE_TYPE', '���պ���', '���պ���', NULL, NULL, NULL, 8),
	('INTEREST_TYPE', '�ܸ�', '�ܸ�', NULL, NULL, NULL, 1),
	('INTEREST_TYPE', '������', '������', NULL, NULL, NULL, 2),
	('INTEREST_TYPE', '������', '������', NULL, NULL, NULL, 3),
	('INVESTMENT_TYPE', '��Ÿ', '��Ÿ', '3', NULL, NULL, 7),
	('INVESTMENT_TYPE', '����', '����', '3', NULL, NULL, 6),
	('INVESTMENT_TYPE', '����', '����', '1', NULL, NULL, 2),
	('INVESTMENT_TYPE', '����', '����', '1', NULL, NULL, 1),
	('INVESTMENT_TYPE', '�ֽ�', '�ֽ�', '2', NULL, NULL, 5),
	('INVESTMENT_TYPE', '�ݵ�', '�ݵ�', '2', NULL, NULL, 4),
	('LOAN_TYPE', '��Ÿ', '��Ÿ', NULL, NULL, NULL, 11),
	('LOAN_TYPE', '���̳ʽ�����', '���̳ʽ�����', NULL, NULL, NULL, 7),
	('LOAN_TYPE', '������', '������', NULL, NULL, NULL, 9),
	('LOAN_TYPE', '�ſ����', '�ſ����', NULL, NULL, NULL, 3),
	('LOAN_TYPE', '����������', '����������', NULL, NULL, NULL, 10),
	('LOAN_TYPE', '�����ڱݴ���', '�����ڱݴ���', NULL, NULL, NULL, 2),
	('LOAN_TYPE', '���ô㺸����', '���ô㺸����', NULL, NULL, NULL, 1),
	('LOAN_TYPE', '�������׺���', '�������׺���', NULL, NULL, NULL, 8),
	('LOAN_TYPE', '�����Է�', '�����Է�', NULL, NULL, NULL, 12),
	('LOAN_TYPE', 'ī�����', 'ī�����', NULL, NULL, NULL, 4),
	('LOAN_TYPE', '���ڱݴ���', '���ڱݴ���', NULL, NULL, NULL, 5),
	('LOAN_TYPE', '�Һα�', '�Һα�', NULL, NULL, NULL, 6),
	('PAYBACK_TYPE', '�����Ͻû�ȯ', '�����Ͻû�ȯ', NULL, NULL, NULL, 1),
	('PAYBACK_TYPE', '���ݱյ��ȯ', '���ݱյ��ȯ', NULL, NULL, NULL, 3),
	('PAYBACK_TYPE', '�����ݱյ��ȯ', '�����ݱյ��ȯ', NULL, NULL, NULL, 2),
	('PAYBACK_TYPE', '������ȯ', '������ȯ', NULL, NULL, NULL, 4),
	('PAY_TERM_TYPE', '�ⳳ', '�ⳳ', NULL, NULL, NULL, 1),
	('PAY_TERM_TYPE', '����', '����', NULL, NULL, NULL, 2),
	('PLAN_TYPE', '�⺻', '�⺻', NULL, NULL, NULL, 1),
	('PLAN_TYPE', '����', '����', NULL, NULL, NULL, 2),
	('TAX', '1.4', '1.4', NULL, NULL, NULL, 2),
	('TAX', '15.4', '15.4', NULL, NULL, NULL, 1),
	('TAX', '�����', '�����', NULL, NULL, NULL, 3);
/*!40000 ALTER TABLE `t_com_common_code` ENABLE KEYS */;

-- ���̺� explan_new.t_com_customer ���� ��������
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

-- ���̺� ������ explan_new.t_com_customer:~12 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_com_customer` DISABLE KEYS */;
INSERT INTO `t_com_customer` (`CUSTOMER_NUM`, `CUSTOMER_NAME`, `BIRTHDAY`, `USER_ID`, `PHONE_NUM`, `EMAIL`, `CREATE_DATE`, `DEL_YN`, `DEL_DATE`) VALUES
	('014da8f0b49e56', 'ddd', '', 'jonsaram', '', '', '2015-05-31 16:47:36', 'Y', NULL),
	('1', '������1', '19741222', 'jonsaram', '010-3252-3102', 'jonnom@nate.com', '2015-01-14 23:43:32', 'N', NULL),
	('14da7cf1dcc30c', '1�׽�Ʈ', '20150708', 'jonsaram', '010-6231-0124', '', '2015-05-31 11:31:18', 'Y', NULL),
	('14da802301729b', '1ssss', '', 'jonsaram', '', '', '2015-05-31 12:27:05', 'Y', NULL),
	('14da8eee3c319f', 's', '', 'jonsaram', '', '', '2015-05-31 16:45:37', 'Y', NULL),
	('14da8ef4b6816e', 'd', '', 'jonsaram', '', '', '2015-05-31 16:46:04', 'Y', NULL),
	('14da8f6bbcd328', 'fv', '', 'jonsaram', '', '', '2015-05-31 16:54:11', 'Y', NULL),
	('14da8fb640a2b9', '1234', '', 'jonsaram', '', '', '2015-05-31 16:59:17', 'Y', NULL),
	('14f685c90c6e40', '������2', '741222', 'jonsaram', '010-3252-3102', 'jonnom@nate.com', '2015-08-26 13:55:41', 'Y', NULL),
	('152cefa05363e8', '������3', '19741222', 'jonsaram', '010-3252-3102', 'jonnom@nate.com', '2016-02-11 15:17:18', 'N', NULL),
	('152cefc7db7294', '������', '19741222', 'jonsaram', '010-3252-3102', 'jonnom@nate.com', '2016-02-11 15:19:59', 'Y', NULL),
	('159aae59800950', '������2', '19741222', 'jonsaram', '010-3252-3102', 'jonnom@nate.com', '2017-01-17 14:28:10', 'Y', NULL);
/*!40000 ALTER TABLE `t_com_customer` ENABLE KEYS */;

-- ���̺� explan_new.t_com_financy_plan_link ���� ��������
CREATE TABLE IF NOT EXISTS `t_com_financy_plan_link` (
  `PLAN_NUM` varchar(14) NOT NULL,
  `FINANCY_NUM` varchar(14) NOT NULL,
  `STATE` char(1) DEFAULT NULL,
  `FINANCY_TYPE` char(1) NOT NULL,
  `CREATE_DATE` datetime NOT NULL,
  `MOD_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`PLAN_NUM`,`FINANCY_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_com_financy_plan_link:~41 rows (�뷫��) ��������
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

-- ���̺� explan_new.t_com_main_menu ���� ��������
CREATE TABLE IF NOT EXISTS `t_com_main_menu` (
  `MAIN_MENU_ID` varchar(20) NOT NULL,
  `MAIN_MENU_NAME` varchar(40) DEFAULT NULL,
  `SORT_ORDER` int(11) DEFAULT NULL,
  PRIMARY KEY (`MAIN_MENU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_com_main_menu:~5 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_com_main_menu` DISABLE KEYS */;
INSERT INTO `t_com_main_menu` (`MAIN_MENU_ID`, `MAIN_MENU_NAME`, `SORT_ORDER`) VALUES
	('CUSTOMER', '��', 1),
	('FINANCY', '�繫', 2),
	('INSURANCE', '����', 3),
	('PURPOSE', '�繫��ǥ', 4),
	('REPORT', '���պ���', 5);
/*!40000 ALTER TABLE `t_com_main_menu` ENABLE KEYS */;

-- ���̺� explan_new.t_com_member ���� ��������
CREATE TABLE IF NOT EXISTS `t_com_member` (
  `USER_ID` varchar(20) NOT NULL,
  `USER_NAME` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_com_member:~0 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_com_member` DISABLE KEYS */;
INSERT INTO `t_com_member` (`USER_ID`, `USER_NAME`) VALUES
	('jonsaram', '������');
/*!40000 ALTER TABLE `t_com_member` ENABLE KEYS */;

-- ���̺� explan_new.t_com_page_info ���� ��������
CREATE TABLE IF NOT EXISTS `t_com_page_info` (
  `PAGE_ID` varchar(20) NOT NULL,
  `URL` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`PAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_com_page_info:~15 rows (�뷫��) ��������
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

-- ���̺� explan_new.t_com_plan ���� ��������
CREATE TABLE IF NOT EXISTS `t_com_plan` (
  `PLAN_NUM` varchar(14) NOT NULL,
  `VERSION_SEQ` varchar(2) DEFAULT NULL,
  `CUSTOMER_NUM` varchar(14) DEFAULT NULL,
  `PLAN_NAME` varchar(50) DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  `START_DATE` varchar(8) DEFAULT NULL,
  `PLAN_TYPE` varchar(4) NOT NULL DEFAULT '�⺻',
  `BASE_PLAN_NUM` varchar(14) DEFAULT NULL,
  `USE_YN` varchar(1) DEFAULT 'Y',
  `DEL_YN` varchar(1) DEFAULT 'N',
  `DEL_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`PLAN_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_com_plan:~19 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_com_plan` DISABLE KEYS */;
INSERT INTO `t_com_plan` (`PLAN_NUM`, `VERSION_SEQ`, `CUSTOMER_NUM`, `PLAN_NAME`, `CREATE_DATE`, `START_DATE`, `PLAN_TYPE`, `BASE_PLAN_NUM`, `USE_YN`, `DEL_YN`, `DEL_DATE`) VALUES
	('14dae5c77e91f6', '1', '1', '�⺻�÷�', '2015-06-01 18:03:25', '20170301', '�⺻', '', 'Y', 'N', NULL),
	('14dae63109d180', '1', '014da8f0b49e56', '�⺻�÷�', '2015-06-01 18:10:37', '20150601', '�⺻', NULL, 'Y', 'N', NULL),
	('14dae636ada3c6', '1', '14da7cf1dcc30c', '�⺻�÷�', '2015-06-01 18:11:00', '20150601', '�⺻', NULL, 'Y', 'N', NULL),
	('14db2161ff3390', '1', '14da8f6bbcd328', '�⺻�÷�', '2015-06-02 11:25:03', '20150602', '�⺻', NULL, 'Y', 'N', NULL),
	('14dbc96389ae20', NULL, '14da8f6bbcd328', '1', '2015-06-04 12:21:11', '2', '�⺻', NULL, 'Y', 'Y', NULL),
	('14dbd3e913f23d', NULL, '14da8f6bbcd328', '1�÷�', '2015-06-04 15:25:03', '20150602', '�⺻', NULL, 'Y', 'Y', NULL),
	('14dbd3e91ca27b', NULL, '14da8f6bbcd328', '2�÷�', '2015-06-04 15:25:03', '20150602', '�⺻', NULL, 'Y', 'N', NULL),
	('14dbd44dd7b188', '1', '14da8fb640a2b9', '�⺻�÷�', '2015-06-04 15:31:56', '20150604', '�⺻', NULL, 'Y', 'N', NULL),
	('14dbd4975df1f3', NULL, '14da8f6bbcd328', '3�÷�', '2015-06-04 15:36:57', '20150602', '�⺻', NULL, 'Y', 'N', NULL),
	('14dbd526e62394', NULL, '1', '1234', '2015-06-04 15:46:45', '20150601', '�⺻', '', 'Y', 'N', NULL),
	('14dbd9dd8b42f0', NULL, '1', '1111', '2015-06-04 17:09:08', '20150601', '�⺻', NULL, 'Y', 'Y', NULL),
	('14dc1792a41150', '1', '14da802301729b', '�⺻�÷�', '2015-06-05 11:07:32', '20150605', '�⺻', NULL, 'Y', 'N', NULL),
	('14dc17952b7285', '1', '14da8ef4b6816e', '�⺻�÷�', '2015-06-05 11:07:43', '20150605', '�⺻', NULL, 'Y', 'N', NULL),
	('152ceff202b3f5', '1', '152cefa05363e8', '�⺻�÷�', '2016-02-11 15:22:52', '20160211', '�⺻', NULL, 'Y', 'N', NULL),
	('159cf440b7d15d', '1', NULL, '�⺻�÷�', '2017-01-24 15:57:40', NULL, '�⺻', NULL, 'Y', 'N', NULL),
	('15a21a937073c5', '1', NULL, '�⺻�÷�', '2017-02-09 15:57:02', NULL, '�⺻', NULL, 'Y', 'N', NULL),
	('15a21aacfaa2c1', '1', NULL, '�⺻�÷�', '2017-02-09 15:58:46', NULL, '�⺻', NULL, 'Y', 'N', NULL),
	('15a21ab1f92780', '1', NULL, '�⺻�÷�', '2017-02-09 15:59:07', NULL, '�⺻', NULL, 'Y', 'N', NULL),
	('15a21addbc6369', '1', NULL, '�⺻�÷�', '2017-02-09 16:02:06', NULL, '�⺻', NULL, 'Y', 'N', NULL);
/*!40000 ALTER TABLE `t_com_plan` ENABLE KEYS */;

-- ���̺� explan_new.t_com_sub_menu ���� ��������
CREATE TABLE IF NOT EXISTS `t_com_sub_menu` (
  `SUB_MENU_ID` varchar(20) NOT NULL,
  `SUB_MENU_NAME` varchar(60) DEFAULT NULL,
  `MAIN_MENU_ID` varchar(20) NOT NULL,
  `PAGE_ID` varchar(20) DEFAULT NULL,
  `SORT_ORDER` int(11) DEFAULT NULL,
  PRIMARY KEY (`SUB_MENU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_com_sub_menu:~14 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_com_sub_menu` DISABLE KEYS */;
INSERT INTO `t_com_sub_menu` (`SUB_MENU_ID`, `SUB_MENU_NAME`, `MAIN_MENU_ID`, `PAGE_ID`, `SORT_ORDER`) VALUES
	('CSH_ANS', '�����帧�м�', 'FINANCY', 'CASHFLOW_ANALYSIS', 6),
	('CSH_MNG', '�����帧����', 'FINANCY', 'CASHFLOW_MANAGE', 4),
	('CST_MNG', '������', 'CUSTOMER', 'CUSTOMER_LIST', 1),
	('FIN_ANS', '�ڻ�м�', 'FINANCY', 'FINANCY_ANALYSIS', 5),
	('FIN_COMP', '�ڻ�񱳺м�', 'FINANCY', '', 7),
	('IMM_MNG', '�ε������', 'FINANCY', 'IMMOVABLE_MANAGE', 2),
	('INS_ANS', '����м�', 'INSURANCE', 'INSURANCE_ANALYSIS', 2),
	('INS_COMP', '����񱳺м�', 'INSURANCE', 'INS_COMPARE_ANALYSIS', 3),
	('INS_MNG', '�������', 'INSURANCE', 'INSURANCE_MANAGE', 1),
	('IVM_MNG', '�����ڻ����', 'FINANCY', 'INVESTMENT_MANAGE', 1),
	('LON_MNG', '��ä����', 'FINANCY', 'LOAN_MANAGE', 3),
	('PUR_MNG', '�繫��ǥ���/����', 'PURPOSE', '', 1),
	('REP_MNG', '���պ������', 'REPORT', 'REPORT_MANAGE', 1),
	('SMS_MNG', 'SMS����', 'CUSTOMER', '', 2);
/*!40000 ALTER TABLE `t_com_sub_menu` ENABLE KEYS */;

-- ���̺� explan_new.t_fin_cashflow ���� ��������
CREATE TABLE IF NOT EXISTS `t_fin_cashflow` (
  `PLAN_NUM` varchar(14) NOT NULL,
  `ITEM_NAME` varchar(20) NOT NULL,
  `ITEM_VALUE` int(11) DEFAULT NULL,
  `ITEM_TYPE` varchar(2) NOT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  `UPDATE_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`PLAN_NUM`,`ITEM_NAME`,`ITEM_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_fin_cashflow:~14 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_fin_cashflow` DISABLE KEYS */;
INSERT INTO `t_fin_cashflow` (`PLAN_NUM`, `ITEM_NAME`, `ITEM_VALUE`, `ITEM_TYPE`, `CREATE_DATE`, `UPDATE_DATE`) VALUES
	('14dae5c77e91f6', '��������', 88, 'CF', '2017-02-24 13:49:41', NULL),
	('14dae5c77e91f6', '������', NULL, 'CF', '2017-03-03 17:21:14', '2017-03-06 16:12:44'),
	('14dae5c77e91f6', '������', NULL, 'CF', '2017-03-06 13:20:06', '2017-03-06 16:12:44'),
	('14dae5c77e91f6', '�ٷμҵ�', 1600, 'IL', '2017-02-23 17:19:42', '2017-02-24 16:44:43'),
	('14dae5c77e91f6', '�����ҵ�', NULL, 'IL', '2017-02-24 13:49:41', '2017-02-24 16:44:43'),
	('14dae5c77e91f6', '��Ÿ', 1, 'CF', '2017-03-06 16:16:12', NULL),
	('14dae5c77e91f6', '��Ÿ', 2, 'CV', '2017-03-06 16:16:12', NULL),
	('14dae5c77e91f6', '��Ÿ', 120, 'CY', '2017-03-06 13:20:06', '2017-03-06 16:36:10'),
	('14dae5c77e91f6', '��Ÿ�ҵ�', NULL, 'IL', '2017-02-24 13:49:41', '2017-02-24 16:44:43'),
	('14dae5c77e91f6', '��Ÿ����', 22, 'CV', '2017-02-24 14:18:09', '2017-02-24 15:33:27'),
	('14dae5c77e91f6', '����(�߼�/�� ��) ���', NULL, 'CY', '2017-03-06 14:45:32', '2017-03-06 16:12:44'),
	('14dae5c77e91f6', '��������', 99, 'CV', '2017-02-24 13:49:41', NULL),
	('14dae5c77e91f6', '����ҵ�', 300, 'IL', '2017-02-23 17:20:03', '2017-02-27 15:24:39'),
	('14dae5c77e91f6', '��Ȱ/������', NULL, 'CV', '2017-03-13 10:30:51', '2017-03-20 10:07:46'),
	('14dae5c77e91f6', '����(��꼼/�ڵ����� ��)', 1200, 'CY', '2017-03-16 17:08:13', '2017-03-16 17:08:50'),
	('14dae5c77e91f6', '���ݼҵ�', NULL, 'IL', '2017-02-24 13:49:41', '2017-02-24 16:44:43'),
	('14dae5c77e91f6', '����', NULL, 'CF', '2017-03-06 13:20:06', '2017-03-06 16:12:44'),
	('14dae5c77e91f6', '�Ӵ�ҵ�', NULL, 'IL', '2017-02-23 17:20:03', '2017-02-24 16:44:16');
/*!40000 ALTER TABLE `t_fin_cashflow` ENABLE KEYS */;

-- ���̺� explan_new.t_fin_category ���� ��������
CREATE TABLE IF NOT EXISTS `t_fin_category` (
  `CATEGORY_NUM` varchar(14) NOT NULL,
  `CATEGORY_NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CATEGORY_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_fin_category:~11 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_fin_category` DISABLE KEYS */;
INSERT INTO `t_fin_category` (`CATEGORY_NUM`, `CATEGORY_NAME`) VALUES
	('11', '��������'),
	('12', '���غ����'),
	('13', '���ܺ�'),
	('14', '������'),
	('15', 'ġ���'),
	('16', '�Կ���'),
	('17', '�Ǽպ���'),
	('18', '�����ں���'),
	('19', 'CI'),
	('20', '���(�¾�)'),
	('21', '��Ÿ');
/*!40000 ALTER TABLE `t_fin_category` ENABLE KEYS */;

-- ���̺� explan_new.t_fin_dambo ���� ��������
CREATE TABLE IF NOT EXISTS `t_fin_dambo` (
  `DAMBO_NUM` varchar(14) NOT NULL,
  `CATEGORY_NUM` varchar(14) NOT NULL,
  `DAMBO_NAME` varchar(50) DEFAULT NULL,
  `USER_ID` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`DAMBO_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_fin_dambo:~163 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_fin_dambo` DISABLE KEYS */;
INSERT INTO `t_fin_dambo` (`DAMBO_NUM`, `CATEGORY_NUM`, `DAMBO_NAME`, `USER_ID`) VALUES
	('1101', '11', '�Ϲݻ��(����)', '*common*'),
	('1102', '11', '�Ϲݻ��(����)', '*common*'),
	('1103', '11', '����/���ػ��', '*common*'),
	('1104', '11', '����/���ػ��(�߰�1)', '*common*'),
	('1105', '11', '����/���ػ��(�߰�2)', '*common*'),
	('1106', '11', '��������/���ػ��', '*common*'),
	('1107', '11', '�������', '*common*'),
	('1108', '11', '�ϻ��', '*common*'),
	('1201', '12', '����/����80%�̻���������', '*common*'),
	('1202', '12', '����/����50%�̻���������', '*common*'),
	('1203', '12', '����/�������ر޿���', '*common*'),
	('1204', '12', '����/�����������ر޿���', '*common*'),
	('1205', '12', '��������/�������ر޿���', '*common*'),
	('1206', '12', '��������/�������ر޿���', '*common*'),
	('1207', '12', '���ϱ�������/�������ر޿���', '*common*'),
	('1208', '12', '���߱����̿�������/����', '*common*'),
	('1301', '13', '�Ϲݾ�', '*common*'),
	('1302', '13', '��׾�', '*common*'),
	('1303', '13', '��輺����', '*common*'),
	('1304', '13', '���ǳ���', '*common*'),
	('1305', '13', '��Ÿ�Ǻξ�', '*common*'),
	('1306', '13', '�������', '*common*'),
	('1307', '13', '����3���', '*common*'),
	('1308', '13', '����3���', '*common*'),
	('1309', '13', '����Ư����', '*common*'),
	('1310', '13', '5��ٺ󵵾�', '*common*'),
	('1311', '13', '������', '*common*'),
	('1312', '13', '������', '*common*'),
	('1313', '13', '�����', '*common*'),
	('1314', '13', '������', '*common*'),
	('1315', '13', '������������ȯ', '*common*'),
	('1316', '13', '�޼��ɱٰ��', '*common*'),
	('1317', '13', '���ذ���', '*common*'),
	('1318', '13', '����ȭ��', '*common*'),
	('1319', '13', '����ȭ��/�ν�', '*common*'),
	('1320', '13', '��ȣ����/ġ��', '*common*'),
	('1321', '13', '����ġ��', '*common*'),
	('1322', '13', '��������ȯ����', '*common*'),
	('1323', '13', '���Ⱓ��ȭ����', '*common*'),
	('1324', '13', '����ź���������', '*common*'),
	('1401', '14', '����', '*common*'),
	('1402', '14', '����', '*common*'),
	('1403', '14', '����/����', '*common*'),
	('1404', '14', '1��~6��(3��,5��)', '*common*'),
	('1405', '14', '�Ϲݾ�', '*common*'),
	('1406', '14', '���ǳ���, ��Ÿ�Ǻξ�', '*common*'),
	('1407', '14', '��輺����', '*common*'),
	('1408', '14', '�������', '*common*'),
	('1409', '14', '�ֿ���ȯ', '*common*'),
	('1410', '14', '7����ȯ', '*common*'),
	('1411', '14', '10����ȯ', '*common*'),
	('1412', '14', '12����ȯ', '*common*'),
	('1413', '14', '16����ȯ', '*common*'),
	('1414', '14', '���ذ���', '*common*'),
	('1415', '14', '����ȭ��', '*common*'),
	('1416', '14', '�������ͺ���', '*common*'),
	('1417', '14', '�ߴ����', '*common*'),
	('1418', '14', '����������', '*common*'),
	('1419', '14', '����Ư����ȯ', '*common*'),
	('1420', '14', '����Ư������(��ȯ)', '*common*'),
	('1421', '14', '����Ư������(��ȯ)', '*common*'),
	('1422', '14', '����������ȯ', '*common*'),
	('1423', '14', '���ΰ���ȯ������', '*common*'),
	('1424', '14', '������������������', '*common*'),
	('1425', '14', '�������ȯ������', '*common*'),
	('1426', '14', '����̽�', '*common*'),
	('1427', '14', '���������̽�', '*common*'),
	('1428', '14', '�����̽�', '*common*'),
	('14ffe081ec018b', '11', '11122', 'jonsaram'),
	('14ffe0857d5208', '11', '222', 'jonsaram'),
	('1501', '15', '��缱/�׾Ͼ๰ġ���', '*common*'),
	('1502', '15', '����Ư����������Ȱġ���', '*common*'),
	('1503c332685180', '14', 'aaa4567', 'jonsaram'),
	('1503c3326872d1', '11', '222333', 'jonsaram'),
	('1601', '16', '����/�����Կ�(1�Ϻ���)', '*common*'),
	('1602', '16', '����/�����Կ�(4�Ϻ���)', '*common*'),
	('1603', '16', '����/�����Կ�(1�Ϻ���)', '*common*'),
	('1604', '16', '����/�����Կ�(4�Ϻ���)', '*common*'),
	('1605', '16', '���������Կ�(4�Ϻ���)', '*common*'),
	('1606', '16', '�����Կ�(1�Ϻ���)', '*common*'),
	('1607', '16', '�����Կ�(4�Ϻ���)', '*common*'),
	('1608', '16', '�����Կ�(31��,91�Ϻ���)', '*common*'),
	('1609', '16', '�����Կ�(31��,91�Ϻ���)', '*common*'),
	('1610', '16', '�Ϲݾ��Կ�', '*common*'),
	('1611', '16', '���ǳ����Կ�', '*common*'),
	('1612', '16', '��輺�����Կ�', '*common*'),
	('1613', '16', '��Ÿ�Ǻξ��Կ�', '*common*'),
	('1614', '16', '�������', '*common*'),
	('1615', '16', '2����Կ�', '*common*'),
	('1616', '16', '3����Կ�', '*common*'),
	('1617', '16', '�ֿ���ȯ�Կ�', '*common*'),
	('1618', '16', '����Ư����ȯ�Կ�', '*common*'),
	('1619', '16', '����Ư������(��ȯ)�Կ�', '*common*'),
	('1620', '16', '����Ư������(��ȯ)�Կ�', '*common*'),
	('1621', '16', '����������ȯ�Կ�', '*common*'),
	('1622', '16', '���ΰ���ȯ�Կ�', '*common*'),
	('1623', '16', '7��~16����ȯ�Կ�', '*common*'),
	('1624', '16', '1��~6��(3��,5��)�����Կ�', '*common*'),
	('1625', '16', '�Ϲݻ��ذ�����', '*common*'),
	('1626', '16', '������ذ�����', '*common*'),
	('1627', '16', '����������', '*common*'),
	('1628', '16', 'ġ�Ű�����', '*common*'),
	('1701', '17', '�����Ƿ��', '*common*'),
	('1702', '17', '�����Կ��Ƿ��', '*common*'),
	('1703', '17', '��������Ƿ��', '*common*'),
	('1704', '17', '�����Կ��Ƿ��', '*common*'),
	('1705', '17', '��������Ƿ��', '*common*'),
	('1706', '17', '��������Կ��Ƿ��', '*common*'),
	('1707', '17', '�Կ��Ƿ��(80%)', '*common*'),
	('1708', '17', '����Ƿ��(80%)', '*common*'),
	('1709', '17', '�����Կ��Ƿ��(90%)', '*common*'),
	('1710', '17', '�����Կ��Ƿ��(90%)', '*common*'),
	('1711', '17', '(��)�����Կ��Ƿ��(90%)', '*common*'),
	('1712', '17', '(��)�����Կ��Ƿ��', '*common*'),
	('1713', '17', '(��)��������Ƿ��', '*common*'),
	('1714', '17', '�ϻ��Ȱ�߹��å��', '*common*'),
	('1715', '17', '�����ϻ��Ȱ�߹��å��', '*common*'),
	('1716', '17', '�ڳ��ϻ��Ȱ�߹��å��', '*common*'),
	('1801', '18', '����', '*common*'),
	('1802', '18', '�����', '*common*'),
	('1803', '18', '�����������α�', '*common*'),
	('1804', '18', '����������α�', '*common*'),
	('1805', '18', '��Ȱ����������', '*common*'),
	('1806', '18', '��������������', '*common*'),
	('1807', '18', 'Ÿ�λ������������������', '*common*'),
	('1808', '18', '�λ����������������', '*common*'),
	('1809', '18', '��޺��', '*common*'),
	('1810', '18', '������ó�����', '*common*'),
	('1811', '18', '�ڵ������������������', '*common*'),
	('1812', '18', '������׾���Ʈ���������������', '*common*'),
	('1813', '18', '�����������α�', '*common*'),
	('1814', '18', '�����κм������α�', '*common*'),
	('1901', '19', '����ź�����', '*common*'),
	('1902', '19', '�ߴ���ȭ��', '*common*'),
	('1903', '19', '����ҷ�������', '*common*'),
	('1904', '19', '�缺������', '*common*'),
	('1905', '19', '���ط����� ���ջ�, ����ջ� ����', '*common*'),
	('1906', '19', '�ߴ�������', '*common*'),
	('1907', '19', '�ߴ��Ѽ���', '*common*'),
	('1908', '19', '���ط������߻�', '*common*'),
	('1909', '19', 'CI', '*common*'),
	('2001', '20', '�������å��', '*common*'),
	('2002', '20', '�����߻��ػ���������', '*common*'),
	('2003', '20', 'Ȧ�ο����ϱ�', '*common*'),
	('2004', '20', '������ǰ�������α�', '*common*'),
	('2005', '20', '���¹������α�', '*common*'),
	('2006', '20', '���ߵ����α�', '*common*'),
	('2007', '20', '���������������α�', '*common*'),
	('2008', '20', '����޿���', '*common*'),
	('2009', '20', '�����޿���', '*common*'),
	('2010', '20', '����ȯ�ޱ�', '*common*'),
	('2011', '20', '�������ϱ�', '*common*'),
	('2012', '20', '�ǰ����ϱ�', '*common*'),
	('2013', '20', '��������', '*common*'),
	('2014', '20', '�ڵ������λ����α�', '*common*'),
	('2101', '21', '��õ�̻������', '*common*'),
	('2102', '21', '��õ�̻��Կ���', '*common*'),
	('2103', '21', '��ü�߾ƺ�����', '*common*'),
	('2104', '21', '�ֻ����ȯ�Կ���', '*common*'),
	('2105', '21', '���(û�ҳ�)�ֿ���ȯ������', '*common*'),
	('2106', '21', '��ǻ�Ͱ�����ȯ������', '*common*'),
	('2107', '21', '�ڳ�Ƚɺ����', '*common*'),
	('2108', '21', 'Ư�����������α�', '*common*');
/*!40000 ALTER TABLE `t_fin_dambo` ENABLE KEYS */;

-- ���̺� explan_new.t_fin_dambo_group ���� ��������
CREATE TABLE IF NOT EXISTS `t_fin_dambo_group` (
  `DAMBO_NUM` varchar(14) NOT NULL,
  `GROUP_NUM` varchar(14) NOT NULL,
  `USER_ID` varchar(20) NOT NULL,
  `PIVOT_VALUE` int(11) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`,`GROUP_NUM`,`DAMBO_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_fin_dambo_group:~49 rows (�뷫��) ��������
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

-- ���̺� explan_new.t_fin_dambo_group_info ���� ��������
CREATE TABLE IF NOT EXISTS `t_fin_dambo_group_info` (
  `USER_ID` varchar(20) NOT NULL,
  `GROUP_NUM` varchar(14) NOT NULL,
  `GROUP_NAME` varchar(50) DEFAULT NULL,
  `BASE_CHECK` varchar(1) DEFAULT NULL,
  `CHART_CHECK` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`,`GROUP_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_fin_dambo_group_info:~3 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_fin_dambo_group_info` DISABLE KEYS */;
INSERT INTO `t_fin_dambo_group_info` (`USER_ID`, `GROUP_NUM`, `GROUP_NAME`, `BASE_CHECK`, `CHART_CHECK`) VALUES
	('jonsaram', '150275a19fbc20', '�⺻ �㺸 �׷�', '1', '0'),
	('jonsaram', '15093557408336', 'Chart �㺸 �׷�', '0', '1'),
	('jonsaram', '1509cc5f36112b', 'Test �㺸 �׷�', '0', '0');
/*!40000 ALTER TABLE `t_fin_dambo_group_info` ENABLE KEYS */;

-- ���̺� explan_new.t_fin_immovable ���� ��������
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

-- ���̺� ������ explan_new.t_fin_immovable:~6 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_fin_immovable` DISABLE KEYS */;
INSERT INTO `t_fin_immovable` (`IMMOVABLE_NUM`, `IMMOVABLE_TYPE`, `IMMOVABLE_NAME`, `IMMOVABLE_VALUE`, `INFLATION_RATE`, `LOCATION`, `COMMENT`, `START_DATE`, `CREATE_DATE`, `DEL_YN`, `DEL_DATE`) VALUES
	('15a184fa5902dc', '', 'wes', NULL, NULL, NULL, NULL, NULL, '2017-02-07 20:22:37', 'Y', '2017-02-07 20:22:59'),
	('15a184ffbbf109', '', '11', 11, 11, '', '', NULL, '2017-02-07 20:22:59', 'Y', '2017-02-08 15:21:16'),
	('15a184ffbc0314', '', '2wes', NULL, NULL, NULL, NULL, NULL, '2017-02-07 20:22:59', 'Y', '2017-02-08 15:21:16'),
	('15a1c629364378', '����', '���� ��������Ʈ ����Ʈ', 46000, 1, '', '', '20100505', '2017-02-08 15:21:46', 'N', NULL),
	('15a1c63e2a3188', '', '�ڻ����� �ڻ����� �ڻ����� �ڻ����� �ڻ�����', 22, 33, '44', '', NULL, '2017-02-08 15:23:12', 'Y', '2017-02-08 18:02:02'),
	('15a454dac462b4', '��', '���� �� ��', 20000, 2, '', '', '20100505', '2017-02-16 14:03:22', 'N', NULL);
/*!40000 ALTER TABLE `t_fin_immovable` ENABLE KEYS */;

-- ���̺� explan_new.t_fin_insurance ���� ��������
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

-- ���̺� ������ explan_new.t_fin_insurance:~12 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_fin_insurance` DISABLE KEYS */;
INSERT INTO `t_fin_insurance` (`INSURANCE_NUM`, `INSURANCE_TYPE`, `COMPANY_NAME`, `TITLE`, `CONTRACTOR`, `PAY_EACH_MONTH`, `START_DATE`, `GUARANTEE_TERM`, `GUARANTEE_TERM_TYPE`, `PAY_TERM`, `PAY_TERM_TYPE`, `COMMENT`, `STATE`, `CREATE_DATE`, `DEL_YN`, `DEL_DATE`) VALUES
	('14f68cddcfb10a', '���ź���', 'A�����', '��������', '������', 50000, '20140505', 100, '�⸸��', 20, '�ⳳ', NULL, NULL, '2015-08-26 15:59:29', 'N', NULL),
	('14f68cf179f32b', '���ź���', 'A�����', '��������', '������', 50000, '20140505', 100, '�⸸��', 20, '�ⳳ', NULL, NULL, '2015-08-26 16:00:49', 'N', NULL),
	('14f68d18c68132', '���ź���', 'A�����', '��������', '������', 50000, '2015-09-01', 100, '������', 60, '����', NULL, NULL, '2015-08-26 16:03:27', 'N', NULL),
	('14f921ba92f182', '�ǰ�����', 'B�����', '���ۺ���', '������', 150000, '2014-06-05', 80, '������', 20, '�ⳳ', NULL, NULL, '2015-09-03 16:28:50', 'N', NULL),
	('150640c980a550', '���ź���', 'B�����', '���ۺ���', '������', 150000, '2014-06-05', 100, '������', 20, '�ⳳ', NULL, NULL, '2015-10-14 10:52:38', 'N', NULL),
	('1508d42776b3c0', '���ź���', 'B�����', '���ۺ���', '������', 150000, '2014-06-05', 100, '������', 20, '�ⳳ', NULL, NULL, '2015-10-22 10:55:54', 'N', NULL),
	('159aaef02e0249', '�ǰ�����', 'B�����', '���ۺ���', '������', 150000, '2014-06-05', 100, '������', 20, '�ⳳ', NULL, NULL, '2017-01-17 14:38:27', 'N', NULL),
	('159cfeb2befb00', '���ź���', 'C�����', '�׳ɺ���', '������', 130000, '2014-06-05', 100, '������', 20, '�ⳳ', NULL, NULL, '2017-01-24 19:00:13', 'N', NULL),
	('159d00bf516150', '���ź���', 'A�����', '��������', '������', 50000, '2015-09-01', 100, '������', 60, '����', NULL, NULL, '2017-01-24 19:36:01', 'Y', NULL),
	('15a1873ebbc231', '���ź���', 'A�����', '��������', '������', 50000, '20150901', 100, '������', 60, '����', NULL, NULL, '2017-02-07 21:02:14', 'N', NULL),
	('15a1873ebbf26f', '�ǰ�����', 'B�����', '���ۺ���', '������', 150000, '20140605', 80, '������', 20, '�ⳳ', NULL, NULL, '2017-02-07 21:02:14', 'N', NULL),
	('15a18745f17148', '���ź���', 'B�����', '���ۺ���', '������', 150000, '20140605', 100, '������', 20, '�ⳳ', NULL, NULL, '2017-02-07 21:02:44', 'N', NULL);
/*!40000 ALTER TABLE `t_fin_insurance` ENABLE KEYS */;

-- ���̺� explan_new.t_fin_insurance_dambo ���� ��������
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

-- ���̺� ������ explan_new.t_fin_insurance_dambo:~27 rows (�뷫��) ��������
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

-- ���̺� explan_new.t_fin_insured ���� ��������
CREATE TABLE IF NOT EXISTS `t_fin_insured` (
  `INSURANCE_NUM` varchar(14) NOT NULL,
  `INSURED_NUM` tinyint(4) NOT NULL,
  `INSURED_NAME` char(18) DEFAULT NULL,
  `INSURED_BIRTH_YEAR` char(18) DEFAULT NULL,
  PRIMARY KEY (`INSURANCE_NUM`,`INSURED_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_fin_insured:~19 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_fin_insured` DISABLE KEYS */;
INSERT INTO `t_fin_insured` (`INSURANCE_NUM`, `INSURED_NUM`, `INSURED_NAME`, `INSURED_BIRTH_YEAR`) VALUES
	('14f68d18c68132', 1, '������', '1974'),
	('14f68d18c68132', 2, '������', '2015'),
	('14f68d18c68132', 3, '������', '1975'),
	('14f921ba92f182', 1, '������', '1974'),
	('150640c980a550', 1, '������', '1979'),
	('1508d42776b3c0', 1, '������', '1979'),
	('159aaef02e0249', 1, '������', '1974'),
	('159cfae01b038a', 1, '������', '1974'),
	('159cfd089232c0', 1, '������', '1974'),
	('159cfeb2befb00', 1, '������', '1974'),
	('159cfff883f2aa', 1, '������', '1974'),
	('159cfff883f2aa', 2, '������', '2015'),
	('159cfff883f2aa', 3, '������', '1975'),
	('159d00bf516150', 1, '������', '1974'),
	('159d00bf516150', 2, '������', '2015'),
	('159d00bf516150', 3, '������', '1975'),
	('15a1873ebbc231', 1, '������', '1974'),
	('15a1873ebbc231', 2, '������', '2015'),
	('15a1873ebbc231', 3, '������', '1975'),
	('15a1873ebbf26f', 1, '������', '1974'),
	('15a18745f17148', 1, '������', '1979');
/*!40000 ALTER TABLE `t_fin_insured` ENABLE KEYS */;

-- ���̺� explan_new.t_fin_investment ���� ��������
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

-- ���̺� ������ explan_new.t_fin_investment:~16 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_fin_investment` DISABLE KEYS */;
INSERT INTO `t_fin_investment` (`INVESTMENT_NUM`, `INVESTMENT_TYPE`, `INVESTMENT_TITLE`, `START_DATE`, `END_TERM`, `INTEREST_RATE`, `INTEREST_TYPE`, `TAX`, `TERM`, `REGULAR_MONEY`, `BASE_MONEY`, `COMMENT`, `CREATE_DATE`, `STATE`, `DEL_YN`, `DEL_DATE`) VALUES
	('15a17fc6fd324d', '����', '����', '20160505', '', '10', '�ܸ�', '1.4', '24', '100000', '', NULL, '2017-02-07 18:51:44', NULL, 'N', NULL),
	('15a17fc6fda2b3', '����', '����', '20160505', '', '10', '�ܸ�', '1.4', '24', '100000', '', NULL, '2017-02-07 18:51:44', NULL, 'N', NULL),
	('15a17fc6fdb189', '����', '����', '20160505', '24', '10', '������', '15.4', '', '', '500000', NULL, '2017-02-07 18:51:44', NULL, 'N', NULL),
	('15a17fd19921ea', '����', '����', '20160505', '', '10', '�ܸ�', '1.4', '24', '100000', '', NULL, '2017-02-07 18:52:27', NULL, 'N', NULL),
	('15a1803f44d25e', '����', '����', '20160505', '', '10', '�ܸ�', '1.4', '24', '100000', '', NULL, '2017-02-07 18:59:56', NULL, 'N', NULL),
	('15a1803f453db0', '����', '����', '20160505', '', '10', '�ܸ�', '1.4', '24', '100000', '', NULL, '2017-02-07 18:59:56', NULL, 'N', NULL),
	('15a1803f455a60', '����', '����', '20160505', '24', '10', '������', '15.4', '', '', '500000', NULL, '2017-02-07 18:59:56', NULL, 'N', NULL),
	('15a180ea9c115d', '����', '����', '20160505', '', '10', '�ܸ�', '1.4', '24', '100000', '', NULL, '2017-02-07 19:11:38', NULL, 'N', NULL),
	('15a180ea9c33ac', '����', '����', '20160505', '', '10', '�ܸ�', '1.4', '24', '100000', '', NULL, '2017-02-07 19:11:38', NULL, 'N', NULL),
	('15a180ea9c5274', '����', '����', '20160505', '24', '10', '������', '15.4', '', '', '500000', NULL, '2017-02-07 19:11:38', NULL, 'N', NULL),
	('15a186722ba23e', '����', '����', '20160505', '24', '10', '������', '15.4', '', '', '500000', NULL, '2017-02-07 20:48:16', NULL, 'Y', '2017-02-07 20:50:17'),
	('15a186722be1de', '����', '����', '20160505', '', '10', '�ܸ�', '1.4', '24', '100000', '', NULL, '2017-02-07 20:48:16', NULL, 'Y', '2017-02-07 20:50:17'),
	('15a18688f881c3', '�ݵ�', '�ݵ�', '20160505', '23', '10', NULL, NULL, '24', '100000', '100000', NULL, '2017-02-07 20:49:50', NULL, 'Y', '2017-02-07 20:50:17'),
	('15a1868b093c20', '�ݵ�', '1�ݵ�', '20160505', '23', '10', NULL, NULL, '24', '100000', '100000', NULL, '2017-02-07 20:49:58', NULL, 'Y', '2017-02-09 16:55:20'),
	('15a21dbc236226', '�ݵ�', '1�ݵ�', '20160505', '23', '10', '������', NULL, '24', '100000', '100000', NULL, '2017-02-09 16:52:14', NULL, 'N', NULL),
	('15a21de96bc300', '����', '����', '20160505', '420', '3', '������', NULL, '120', '100000', '0', NULL, '2017-02-09 16:55:20', NULL, 'N', NULL),
	('15aea03d5f829b', '��Ÿ', '��Ÿ', '20160505', '420', '3', '������', NULL, '120', '100000', '0', NULL, '2017-03-20 13:40:04', NULL, 'N', NULL),
	('15aea28ed73335', '�ֽ�', '�ֽ�', '20160505', '23', '10', '������', NULL, '24', '100000', '100000', NULL, '2017-03-20 14:20:35', NULL, 'N', NULL);
/*!40000 ALTER TABLE `t_fin_investment` ENABLE KEYS */;

-- ���̺� explan_new.t_fin_investment_subdata ���� ��������
CREATE TABLE IF NOT EXISTS `t_fin_investment_subdata` (
  `INVESTMENT_NUM` varchar(14) NOT NULL,
  `PRE_FEE` varchar(4) DEFAULT NULL,
  `AFTER_PRE_FEE` varchar(4) DEFAULT NULL,
  `PRE_FEE2` varchar(4) DEFAULT NULL,
  `NORMAL_FEE` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`INVESTMENT_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ���̺� ������ explan_new.t_fin_investment_subdata:~6 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_fin_investment_subdata` DISABLE KEYS */;
INSERT INTO `t_fin_investment_subdata` (`INVESTMENT_NUM`, `PRE_FEE`, `AFTER_PRE_FEE`, `PRE_FEE2`, `NORMAL_FEE`) VALUES
	('15a0d6b3ffa14a', NULL, NULL, NULL, '1.5'),
	('15a12631eb0140', '13', '', '', '1'),
	('15a18688f881c3', NULL, NULL, NULL, '11'),
	('15a1868b093c20', NULL, NULL, NULL, '11'),
	('15a21dbc236226', NULL, NULL, NULL, '1'),
	('15a21de96bc300', '7', '10', '3.5', '1');
/*!40000 ALTER TABLE `t_fin_investment_subdata` ENABLE KEYS */;

-- ���̺� explan_new.t_fin_loan ���� ��������
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

-- ���̺� ������ explan_new.t_fin_loan:~8 rows (�뷫��) ��������
/*!40000 ALTER TABLE `t_fin_loan` DISABLE KEYS */;
INSERT INTO `t_fin_loan` (`LOAN_NUM`, `LOAN_TYPE`, `LOAN_COMPANY`, `LOAN_TOTAL`, `LOAN_RATE`, `START_DATE`, `KUCHI_TERM`, `PAYBACK_TERM`, `PAYBACK_TYPE`, `PAYBACK_EACH_MONTH`, `COMMENT`, `CREATE_DATE`, `DEL_YN`, `DEL_DATE`) VALUES
	('15a1d476767331', '3', '2', 2, 2, '1', 2, 0, '1', 2, '2', '2017-02-08 19:31:43', 'Y', '2017-02-08 19:35:42'),
	('15a1d4ada77214', '1', '2', 2, 2, '1', 2, 0, '1', 2, '2', '2017-02-08 19:35:29', 'Y', '2017-02-08 19:36:48'),
	('15a1d4bd7dc218', '1', '2', 2, 2, '1', 2, 0, '1', 2, '2', '2017-02-08 19:36:34', 'Y', '2017-02-08 19:38:18'),
	('15a1d4bd7dd3be', '1', '2', 2, 2, '1', 2, 0, '1', 2, '2', '2017-02-08 19:36:34', 'Y', '2017-02-08 19:38:18'),
	('15a1d4c0e9e318', '1', '2', 2, 2, '1', 2, 0, '1', 2, '2', '2017-02-08 19:36:48', 'Y', '2017-02-08 19:38:18'),
	('15a22e01d213ff', '���ô㺸����', '�츮', 10000, 10, '20170101', 12, NULL, '�����Ͻû�ȯ', 833333, '1111', '2017-02-09 21:36:37', 'Y', '2017-02-10 18:54:36'),
	('15a25c6bc902e1', '�ſ����', '����', 10000, 10, '20150101', NULL, 24, '�����ݱյ��ȯ', 4614493, '1111', '2017-02-10 11:07:45', 'Y', '2017-02-10 17:51:01'),
	('15a2762eedf3df', '���ô㺸����', '�츮', 10000, 10, '20170101', NULL, 12, '�����ݱյ��ȯ', 8791589, '1111', '2017-02-10 18:37:59', 'N', NULL),
	('15a3b9f9e7c14c', '�ſ����', '�츮', 20000, 10, '20170101', 12, 120, '�����ݱյ��ȯ', 1666667, '1111', '2017-02-14 16:56:40', 'N', NULL);
/*!40000 ALTER TABLE `t_fin_loan` ENABLE KEYS */;

-- �� explan_new.v_com_customer ���� ��������
-- VIEW ���Ӽ� ������ �غ��ϱ� ���� �ӽ� ���̺��� �����մϴ�.
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

-- �� explan_new.v_com_plan ���� ��������
-- VIEW ���Ӽ� ������ �غ��ϱ� ���� �ӽ� ���̺��� �����մϴ�.
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

-- �� explan_new.v_com_customer ���� ��������
-- �ӽ� ���̺��� �����ϰ� ���� VIEW ������ ����
DROP TABLE IF EXISTS `v_com_customer`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_com_customer` AS select `t_com_customer`.`CUSTOMER_NUM` AS `CUSTOMER_NUM`,`t_com_customer`.`CUSTOMER_NAME` AS `CUSTOMER_NAME`,`t_com_customer`.`BIRTHDAY` AS `BIRTHDAY`,`t_com_customer`.`USER_ID` AS `USER_ID`,`t_com_customer`.`PHONE_NUM` AS `PHONE_NUM`,`t_com_customer`.`EMAIL` AS `EMAIL`,`t_com_customer`.`CREATE_DATE` AS `CREATE_DATE`,`t_com_customer`.`DEL_YN` AS `DEL_YN`,`t_com_customer`.`DEL_DATE` AS `DEL_DATE` from `t_com_customer` where (`t_com_customer`.`DEL_YN` = 'N') ;

-- �� explan_new.v_com_plan ���� ��������
-- �ӽ� ���̺��� �����ϰ� ���� VIEW ������ ����
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
