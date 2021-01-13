/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80020
 Source Host           : localhost:3306
 Source Schema         : biechu

 Target Server Type    : MySQL
 Target Server Version : 80020
 File Encoding         : 65001

 Date: 13/01/2021 17:28:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `userId` int NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `phone` decimal(11, 0) NULL DEFAULT NULL COMMENT '手机号码',
  `email` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Email',
  `password` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `errorTime` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '错误登录时间',
  `nickName` char(14) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `level` tinyint NULL DEFAULT NULL COMMENT '等级',
  `banTime` datetime(0) NULL DEFAULT NULL COMMENT '黑名单到期时间',
  `fame` int NULL DEFAULT NULL COMMENT '声望',
  `guildId` int NULL DEFAULT NULL COMMENT '公会ID',
  `place` tinyint NULL DEFAULT NULL COMMENT '公会头衔',
  `gold` int(10) UNSIGNED ZEROFILL NULL DEFAULT NULL COMMENT '金币',
  `loginIP` decimal(10, 0) NULL DEFAULT NULL COMMENT '登录IP',
  `loginTime` datetime(0) NULL DEFAULT NULL COMMENT '登录时间',
  `registerIP` decimal(10, 0) NULL DEFAULT NULL COMMENT '注册IP',
  `registerTime` datetime(0) NULL DEFAULT NULL COMMENT '注册时间',
  PRIMARY KEY (`userId`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 13857781950, 'admin@biechu.com', NULL, '2021-01-13 17:27:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 111111, NULL, 1111111111, '2021-01-13 14:44:26');

SET FOREIGN_KEY_CHECKS = 1;
