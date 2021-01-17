
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`
(
  `userId` int NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `name` char
(16) CHARACTER
SET utf8
COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` char
(32) CHARACTER
SET utf8
COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `email` char
(64) CHARACTER
SET utf8
COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Email',
  `phone` decimal
(11, 0) NULL DEFAULT NULL COMMENT '手机号码',
  `errorTime` datetime
(0) NULL DEFAULT NULL ON
UPDATE CURRENT_TIMESTAMP(0) COMMENT '错误登录时间',
  `nickName
` char
(16) CHARACTER
SET utf8
COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `level` tinyint
(1) NULL DEFAULT NULL COMMENT '等级',
  `banTime` datetime
(0) NULL DEFAULT NULL COMMENT '黑名单到期时间',
  `fame` int NULL DEFAULT NULL COMMENT '声望',
  `guildId` int NULL DEFAULT NULL COMMENT '公会ID',
  `place` tinyint
(1) NULL DEFAULT NULL COMMENT '公会头衔',
  `gold` mediumint
(10) UNSIGNED ZEROFILL NULL DEFAULT NULL COMMENT '金币',
  `loginIP` decimal
(15, 0) NULL DEFAULT NULL COMMENT '登录IP',
  `loginTime` datetime
(0) NULL DEFAULT NULL COMMENT '登录时间',
  `registerIP` decimal
(15, 0) NULL DEFAULT NULL COMMENT '注册IP',
  `registerTime` datetime
(0) NULL DEFAULT NULL COMMENT '注册时间',
  PRIMARY KEY
(`userId`) USING BTREE,
  INDEX `idx_name`
(`name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER
SET = utf8
COLLATE = utf8_general_ci ROW_FORMAT = Fixed;

