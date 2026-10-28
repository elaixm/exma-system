/*
 Navicat Premium Data Transfer

 Source Server         : root
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3306
 Source Schema         : exam_system

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 17/01/2026 15:11:33
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for exam_logs
-- ----------------------------
DROP TABLE IF EXISTS `exam_logs`;
CREATE TABLE `exam_logs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `exam_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `exam_id`(`exam_id` ASC) USING BTREE,
  INDEX `student_id`(`student_id` ASC) USING BTREE,
  CONSTRAINT `exam_logs_ibfk_1` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `exam_logs_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 184 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_logs
-- ----------------------------
INSERT INTO `exam_logs` VALUES (1, 1, 4, 'START_EXAM', '开始考试', '192.168.1.101', '2025-12-30 11:02:13');
INSERT INTO `exam_logs` VALUES (2, 1, 4, 'SAVE_ANSWER', '保存答案', '192.168.1.101', '2025-12-30 11:12:13');
INSERT INTO `exam_logs` VALUES (3, 1, 4, 'SAVE_ANSWER', '保存答案', '192.168.1.101', '2025-12-30 11:22:13');
INSERT INTO `exam_logs` VALUES (4, 1, 4, 'SUBMIT_EXAM', '提交考试', '192.168.1.101', '2025-12-30 11:52:13');
INSERT INTO `exam_logs` VALUES (5, 1, 5, 'START_EXAM', '开始考试', '192.168.1.102', '2025-12-30 11:02:13');
INSERT INTO `exam_logs` VALUES (6, 1, 5, 'SAVE_ANSWER', '保存答案', '192.168.1.102', '2025-12-30 11:17:13');
INSERT INTO `exam_logs` VALUES (7, 1, 5, 'SUBMIT_EXAM', '提交考试', '192.168.1.102', '2025-12-30 11:57:13');
INSERT INTO `exam_logs` VALUES (8, 2, 4, 'START_EXAM', '开始考试', '192.168.1.101', '2026-01-01 11:02:13');
INSERT INTO `exam_logs` VALUES (9, 2, 4, 'SAVE_ANSWER', '保存答案', '192.168.1.101', '2026-01-01 11:14:13');
INSERT INTO `exam_logs` VALUES (10, 2, 4, 'SUBMIT_EXAM', '提交考试', '192.168.1.101', '2026-01-01 11:54:13');
INSERT INTO `exam_logs` VALUES (11, 2, 5, 'START_EXAM', '开始考试', '192.168.1.102', '2026-01-01 11:02:13');
INSERT INTO `exam_logs` VALUES (12, 2, 5, 'SAVE_ANSWER', '保存答案', '192.168.1.102', '2026-01-01 11:20:13');
INSERT INTO `exam_logs` VALUES (13, 2, 5, 'SUBMIT_EXAM', '提交考试', '192.168.1.102', '2026-01-01 12:00:13');
INSERT INTO `exam_logs` VALUES (14, 3, 4, 'START_EXAM', '开始考试', '192.168.1.101', '2026-01-06 10:32:13');
INSERT INTO `exam_logs` VALUES (15, 3, 4, 'SAVE_ANSWER', '保存答案', '192.168.1.101', '2026-01-06 10:42:13');
INSERT INTO `exam_logs` VALUES (16, 3, 4, 'SAVE_ANSWER', '保存答案', '192.168.1.101', '2026-01-06 10:52:13');
INSERT INTO `exam_logs` VALUES (17, 3, 5, 'START_EXAM', '开始考试', '192.168.1.102', '2026-01-06 10:47:13');
INSERT INTO `exam_logs` VALUES (18, 7, 4, 'START_EXAM', '开始考试', '192.168.1.101', '2025-12-27 11:02:13');
INSERT INTO `exam_logs` VALUES (19, 7, 4, 'SAVE_ANSWER', '保存答案', '192.168.1.101', '2025-12-27 11:17:13');
INSERT INTO `exam_logs` VALUES (20, 7, 4, 'SUBMIT_EXAM', '提交考试', '192.168.1.101', '2025-12-27 11:57:13');
INSERT INTO `exam_logs` VALUES (21, 7, 5, 'START_EXAM', '开始考试', '192.168.1.102', '2025-12-27 11:02:13');
INSERT INTO `exam_logs` VALUES (22, 7, 5, 'SAVE_ANSWER', '保存答案', '192.168.1.102', '2025-12-27 11:22:13');
INSERT INTO `exam_logs` VALUES (23, 7, 5, 'SUBMIT_EXAM', '提交考试', '192.168.1.102', '2025-12-27 12:00:13');
INSERT INTO `exam_logs` VALUES (24, 7, 6, 'START_EXAM', '开始考试', '192.168.1.103', '2025-12-27 11:02:13');
INSERT INTO `exam_logs` VALUES (25, 7, 6, 'SAVE_ANSWER', '保存答案', '192.168.1.103', '2025-12-27 11:20:13');
INSERT INTO `exam_logs` VALUES (26, 7, 6, 'SUBMIT_EXAM', '提交考试', '192.168.1.103', '2025-12-27 11:54:13');
INSERT INTO `exam_logs` VALUES (27, 8, 4, 'START_EXAM', '开始考试', '192.168.1.101', '2025-12-29 11:02:13');
INSERT INTO `exam_logs` VALUES (28, 8, 4, 'SAVE_ANSWER', '保存答案', '192.168.1.101', '2025-12-29 11:14:13');
INSERT INTO `exam_logs` VALUES (29, 8, 4, 'SUBMIT_EXAM', '提交考试', '192.168.1.101', '2025-12-29 11:58:13');
INSERT INTO `exam_logs` VALUES (30, 8, 5, 'START_EXAM', '开始考试', '192.168.1.102', '2025-12-29 11:02:13');
INSERT INTO `exam_logs` VALUES (31, 8, 5, 'SAVE_ANSWER', '保存答案', '192.168.1.102', '2025-12-29 11:18:13');
INSERT INTO `exam_logs` VALUES (32, 8, 5, 'SUBMIT_EXAM', '提交考试', '192.168.1.102', '2025-12-29 12:01:13');
INSERT INTO `exam_logs` VALUES (33, 8, 6, 'START_EXAM', '开始考试', '192.168.1.103', '2025-12-29 11:02:13');
INSERT INTO `exam_logs` VALUES (34, 8, 6, 'SAVE_ANSWER', '保存答案', '192.168.1.103', '2025-12-29 11:12:13');
INSERT INTO `exam_logs` VALUES (35, 8, 6, 'SUBMIT_EXAM', '提交考试', '192.168.1.103', '2025-12-29 11:52:13');
INSERT INTO `exam_logs` VALUES (36, 9, 4, 'START_EXAM', '开始考试', '192.168.1.101', '2025-12-31 11:02:13');
INSERT INTO `exam_logs` VALUES (37, 9, 4, 'SAVE_ANSWER', '保存答案', '192.168.1.101', '2025-12-31 11:16:13');
INSERT INTO `exam_logs` VALUES (38, 9, 4, 'SUBMIT_EXAM', '提交考试', '192.168.1.101', '2025-12-31 11:56:13');
INSERT INTO `exam_logs` VALUES (39, 9, 5, 'START_EXAM', '开始考试', '192.168.1.102', '2025-12-31 11:02:13');
INSERT INTO `exam_logs` VALUES (40, 9, 5, 'SAVE_ANSWER', '保存答案', '192.168.1.102', '2025-12-31 11:20:13');
INSERT INTO `exam_logs` VALUES (41, 9, 5, 'SUBMIT_EXAM', '提交考试', '192.168.1.102', '2025-12-31 11:59:13');
INSERT INTO `exam_logs` VALUES (42, 9, 6, 'START_EXAM', '开始考试', '192.168.1.103', '2025-12-31 11:02:13');
INSERT INTO `exam_logs` VALUES (43, 9, 6, 'SAVE_ANSWER', '保存答案', '192.168.1.103', '2025-12-31 11:10:13');
INSERT INTO `exam_logs` VALUES (44, 9, 6, 'SUBMIT_EXAM', '提交考试', '192.168.1.103', '2025-12-31 11:50:13');
INSERT INTO `exam_logs` VALUES (45, 10, 4, 'START_EXAM', '开始考试', '192.168.1.101', '2026-01-02 11:02:13');
INSERT INTO `exam_logs` VALUES (46, 10, 4, 'SAVE_ANSWER', '保存答案', '192.168.1.101', '2026-01-02 11:15:13');
INSERT INTO `exam_logs` VALUES (47, 10, 4, 'SUBMIT_EXAM', '提交考试', '192.168.1.101', '2026-01-02 11:55:13');
INSERT INTO `exam_logs` VALUES (48, 10, 5, 'START_EXAM', '开始考试', '192.168.1.102', '2026-01-02 11:02:13');
INSERT INTO `exam_logs` VALUES (49, 10, 5, 'SAVE_ANSWER', '保存答案', '192.168.1.102', '2026-01-02 11:19:13');
INSERT INTO `exam_logs` VALUES (50, 10, 5, 'SUBMIT_EXAM', '提交考试', '192.168.1.102', '2026-01-02 11:58:13');
INSERT INTO `exam_logs` VALUES (51, 10, 6, 'START_EXAM', '开始考试', '192.168.1.103', '2026-01-02 11:02:13');
INSERT INTO `exam_logs` VALUES (52, 10, 6, 'SAVE_ANSWER', '保存答案', '192.168.1.103', '2026-01-02 11:11:13');
INSERT INTO `exam_logs` VALUES (53, 10, 6, 'SUBMIT_EXAM', '提交考试', '192.168.1.103', '2026-01-02 11:47:13');
INSERT INTO `exam_logs` VALUES (54, 4, 4, 'START_EXAM', '开始考试', '0:0:0:0:0:0:0:1', '2026-01-06 15:22:15');
INSERT INTO `exam_logs` VALUES (55, 4, 4, 'SAVE_ANSWER', '保存答案', '0:0:0:0:0:0:0:1', '2026-01-06 15:22:46');
INSERT INTO `exam_logs` VALUES (56, 4, 4, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 15:34:27');
INSERT INTO `exam_logs` VALUES (57, 4, 4, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 15:34:55');
INSERT INTO `exam_logs` VALUES (58, 4, 4, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 15:34:56');
INSERT INTO `exam_logs` VALUES (59, 4, 4, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 15:38:55');
INSERT INTO `exam_logs` VALUES (60, 4, 4, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 15:38:57');
INSERT INTO `exam_logs` VALUES (61, 4, 4, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 15:39:20');
INSERT INTO `exam_logs` VALUES (62, 4, 4, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 15:39:21');
INSERT INTO `exam_logs` VALUES (63, 4, 4, 'SUBMIT_EXAM', '提交考试', '0:0:0:0:0:0:0:1', '2026-01-06 15:39:26');
INSERT INTO `exam_logs` VALUES (64, 3, 4, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 16:26:59');
INSERT INTO `exam_logs` VALUES (65, 3, 4, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 16:27:00');
INSERT INTO `exam_logs` VALUES (66, 3, 4, 'SUBMIT_EXAM', '提交考试', '0:0:0:0:0:0:0:1', '2026-01-06 16:27:14');
INSERT INTO `exam_logs` VALUES (67, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 16:30:39');
INSERT INTO `exam_logs` VALUES (68, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 16:31:34');
INSERT INTO `exam_logs` VALUES (69, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 16:31:35');
INSERT INTO `exam_logs` VALUES (70, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 16:31:42');
INSERT INTO `exam_logs` VALUES (71, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 16:31:42');
INSERT INTO `exam_logs` VALUES (72, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 16:38:02');
INSERT INTO `exam_logs` VALUES (73, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 16:38:03');
INSERT INTO `exam_logs` VALUES (74, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 16:38:27');
INSERT INTO `exam_logs` VALUES (75, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 16:38:28');
INSERT INTO `exam_logs` VALUES (76, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 16:39:09');
INSERT INTO `exam_logs` VALUES (77, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 16:39:10');
INSERT INTO `exam_logs` VALUES (78, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 16:40:03');
INSERT INTO `exam_logs` VALUES (79, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 16:40:03');
INSERT INTO `exam_logs` VALUES (80, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 17:24:29');
INSERT INTO `exam_logs` VALUES (81, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 17:24:29');
INSERT INTO `exam_logs` VALUES (82, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 17:27:42');
INSERT INTO `exam_logs` VALUES (83, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 17:27:43');
INSERT INTO `exam_logs` VALUES (84, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 17:35:59');
INSERT INTO `exam_logs` VALUES (85, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 17:36:01');
INSERT INTO `exam_logs` VALUES (86, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 17:36:04');
INSERT INTO `exam_logs` VALUES (87, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 17:36:05');
INSERT INTO `exam_logs` VALUES (88, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 19:17:54');
INSERT INTO `exam_logs` VALUES (89, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 19:17:56');
INSERT INTO `exam_logs` VALUES (90, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 19:18:00');
INSERT INTO `exam_logs` VALUES (91, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 19:18:01');
INSERT INTO `exam_logs` VALUES (92, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 19:20:33');
INSERT INTO `exam_logs` VALUES (93, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 19:20:34');
INSERT INTO `exam_logs` VALUES (94, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 19:20:53');
INSERT INTO `exam_logs` VALUES (95, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 19:20:54');
INSERT INTO `exam_logs` VALUES (96, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 19:33:36');
INSERT INTO `exam_logs` VALUES (97, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 19:33:37');
INSERT INTO `exam_logs` VALUES (98, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 21:24:35');
INSERT INTO `exam_logs` VALUES (99, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 21:24:36');
INSERT INTO `exam_logs` VALUES (100, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 21:24:37');
INSERT INTO `exam_logs` VALUES (101, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 21:24:41');
INSERT INTO `exam_logs` VALUES (102, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 21:24:47');
INSERT INTO `exam_logs` VALUES (103, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 21:24:48');
INSERT INTO `exam_logs` VALUES (104, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 21:25:20');
INSERT INTO `exam_logs` VALUES (105, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 21:25:22');
INSERT INTO `exam_logs` VALUES (106, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 21:25:56');
INSERT INTO `exam_logs` VALUES (107, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 21:25:56');
INSERT INTO `exam_logs` VALUES (108, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 21:26:09');
INSERT INTO `exam_logs` VALUES (109, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 21:26:09');
INSERT INTO `exam_logs` VALUES (110, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 21:27:21');
INSERT INTO `exam_logs` VALUES (111, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 21:27:21');
INSERT INTO `exam_logs` VALUES (112, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 21:27:25');
INSERT INTO `exam_logs` VALUES (113, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 21:27:28');
INSERT INTO `exam_logs` VALUES (114, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 21:28:10');
INSERT INTO `exam_logs` VALUES (115, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 21:28:10');
INSERT INTO `exam_logs` VALUES (116, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 21:28:12');
INSERT INTO `exam_logs` VALUES (117, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 21:28:13');
INSERT INTO `exam_logs` VALUES (118, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 21:31:31');
INSERT INTO `exam_logs` VALUES (119, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 21:51:51');
INSERT INTO `exam_logs` VALUES (120, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:21:45');
INSERT INTO `exam_logs` VALUES (121, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:22:12');
INSERT INTO `exam_logs` VALUES (122, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:22:13');
INSERT INTO `exam_logs` VALUES (123, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:23:10');
INSERT INTO `exam_logs` VALUES (124, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:28:00');
INSERT INTO `exam_logs` VALUES (125, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:28:00');
INSERT INTO `exam_logs` VALUES (126, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:28:02');
INSERT INTO `exam_logs` VALUES (127, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:28:02');
INSERT INTO `exam_logs` VALUES (128, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:32:06');
INSERT INTO `exam_logs` VALUES (129, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:32:06');
INSERT INTO `exam_logs` VALUES (130, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:32:10');
INSERT INTO `exam_logs` VALUES (131, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:32:10');
INSERT INTO `exam_logs` VALUES (132, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:35:11');
INSERT INTO `exam_logs` VALUES (133, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:35:12');
INSERT INTO `exam_logs` VALUES (134, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:43:43');
INSERT INTO `exam_logs` VALUES (135, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:43:44');
INSERT INTO `exam_logs` VALUES (136, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:43:49');
INSERT INTO `exam_logs` VALUES (137, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:43:50');
INSERT INTO `exam_logs` VALUES (138, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:46:22');
INSERT INTO `exam_logs` VALUES (139, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:46:23');
INSERT INTO `exam_logs` VALUES (140, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:49:37');
INSERT INTO `exam_logs` VALUES (141, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:49:40');
INSERT INTO `exam_logs` VALUES (142, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:49:57');
INSERT INTO `exam_logs` VALUES (143, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:49:58');
INSERT INTO `exam_logs` VALUES (144, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:55:01');
INSERT INTO `exam_logs` VALUES (145, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:55:01');
INSERT INTO `exam_logs` VALUES (146, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:55:15');
INSERT INTO `exam_logs` VALUES (147, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:55:18');
INSERT INTO `exam_logs` VALUES (148, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:55:47');
INSERT INTO `exam_logs` VALUES (149, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:55:49');
INSERT INTO `exam_logs` VALUES (150, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:55:50');
INSERT INTO `exam_logs` VALUES (151, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:55:54');
INSERT INTO `exam_logs` VALUES (152, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 22:55:56');
INSERT INTO `exam_logs` VALUES (153, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 22:56:02');
INSERT INTO `exam_logs` VALUES (154, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:01:21');
INSERT INTO `exam_logs` VALUES (155, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:01:23');
INSERT INTO `exam_logs` VALUES (156, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:01:27');
INSERT INTO `exam_logs` VALUES (157, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:01:27');
INSERT INTO `exam_logs` VALUES (158, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:03:23');
INSERT INTO `exam_logs` VALUES (159, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:03:24');
INSERT INTO `exam_logs` VALUES (160, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:03:25');
INSERT INTO `exam_logs` VALUES (161, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:03:26');
INSERT INTO `exam_logs` VALUES (162, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:08:32');
INSERT INTO `exam_logs` VALUES (163, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:08:33');
INSERT INTO `exam_logs` VALUES (164, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:08:54');
INSERT INTO `exam_logs` VALUES (165, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:23:55');
INSERT INTO `exam_logs` VALUES (166, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:27:52');
INSERT INTO `exam_logs` VALUES (167, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:27:54');
INSERT INTO `exam_logs` VALUES (168, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:31:05');
INSERT INTO `exam_logs` VALUES (169, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:31:06');
INSERT INTO `exam_logs` VALUES (170, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:31:34');
INSERT INTO `exam_logs` VALUES (171, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:31:36');
INSERT INTO `exam_logs` VALUES (172, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:35:06');
INSERT INTO `exam_logs` VALUES (173, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:35:07');
INSERT INTO `exam_logs` VALUES (174, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:35:08');
INSERT INTO `exam_logs` VALUES (175, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:35:09');
INSERT INTO `exam_logs` VALUES (176, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:45:24');
INSERT INTO `exam_logs` VALUES (177, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:45:29');
INSERT INTO `exam_logs` VALUES (178, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:47:04');
INSERT INTO `exam_logs` VALUES (179, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:47:07');
INSERT INTO `exam_logs` VALUES (180, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-06 23:47:08');
INSERT INTO `exam_logs` VALUES (181, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-06 23:47:09');
INSERT INTO `exam_logs` VALUES (182, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台', '0:0:0:0:0:0:0:1', '2026-01-07 10:22:54');
INSERT INTO `exam_logs` VALUES (183, 3, 1, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台', '0:0:0:0:0:0:0:1', '2026-01-07 10:22:55');

-- ----------------------------
-- Table structure for exam_records
-- ----------------------------
DROP TABLE IF EXISTS `exam_records`;
CREATE TABLE `exam_records`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `exam_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  `answers` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `score` int NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `start_time` datetime NULL DEFAULT NULL,
  `submit_time` datetime NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `exam_id`(`exam_id` ASC) USING BTREE,
  INDEX `student_id`(`student_id` ASC) USING BTREE,
  CONSTRAINT `exam_records_ibfk_1` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `exam_records_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_records
-- ----------------------------
INSERT INTO `exam_records` VALUES (1, 1, 4, '1:A;6:A,C;11:正确;16:李白;21:中国古代四大名著包括《红楼梦》、《西游记》、《水浒传》、《三国演义》', 45, 'FINISHED', '192.168.1.101', '2025-12-30 11:02:13', '2025-12-30 11:52:13', '2025-12-30 11:02:13', '2025-12-30 11:52:13');
INSERT INTO `exam_records` VALUES (2, 1, 5, '1:A;6:A,C,D;11:正确;16:李白;21:四大名著包括《红楼梦》作者曹雪芹、《西游记》作者吴承恩等', 48, 'FINISHED', '192.168.1.102', '2025-12-30 11:02:13', '2025-12-30 11:57:13', '2025-12-30 11:02:13', '2025-12-30 11:57:13');
INSERT INTO `exam_records` VALUES (3, 1, 6, '1:B;6:A,C;11:错误;16:杜甫;21:四大名著是中国古典文学', 35, 'FINISHED', '192.168.1.103', '2025-12-30 11:02:13', '2025-12-30 11:47:13', '2025-12-30 11:02:13', '2025-12-30 11:47:13');
INSERT INTO `exam_records` VALUES (4, 2, 4, '2:A;7:A,B,C;12:正确;17:180;22:勾股定理是a²+b²=c²，可以用几何法证明', 42, 'FINISHED', '192.168.1.101', '2026-01-01 11:02:13', '2026-01-01 11:54:13', '2026-01-01 11:02:13', '2026-01-01 11:54:13');
INSERT INTO `exam_records` VALUES (5, 2, 5, '2:A;7:A,B,C,D;12:正确;17:180;22:勾股定理在直角三角形中成立', 46, 'FINISHED', '192.168.1.102', '2026-01-01 11:02:13', '2026-01-01 12:00:13', '2026-01-01 11:02:13', '2026-01-01 12:00:13');
INSERT INTO `exam_records` VALUES (6, 2, 6, '2:B;7:A,B;12:错误;17:90;22:勾股定理很重要', 38, 'FINISHED', '192.168.1.103', '2026-01-01 11:02:13', '2026-01-01 11:50:13', '2026-01-01 11:02:13', '2026-01-01 11:50:13');
INSERT INTO `exam_records` VALUES (7, 2, 7, '2:A;7:A,B,C,D;12:正确;17:180;22:勾股定理：在直角三角形中，两条直角边的平方和等于斜边的平方，即a²+b²=c²', 50, 'FINISHED', '192.168.1.104', '2026-01-01 11:02:13', '2026-01-01 12:02:13', '2026-01-01 11:02:13', '2026-01-01 12:02:13');
INSERT INTO `exam_records` VALUES (8, 3, 4, '3:C;8:A,C,E;13:正确;18:morning;23:英语时态分为现在时、过去时、将来时', 5, 'FINISHED', '192.168.1.101', '2026-01-06 10:32:13', '2026-01-06 16:27:14', '2026-01-06 10:32:13', '2026-01-06 16:27:14');
INSERT INTO `exam_records` VALUES (9, 3, 5, NULL, NULL, 'IN_PROGRESS', '192.168.1.102', '2026-01-06 10:47:13', NULL, '2026-01-06 10:47:13', '2026-01-06 11:02:13');
INSERT INTO `exam_records` VALUES (10, 7, 4, '26:A;31:A,C,E;36:正确;41:施耐庵;46:《红楼梦》主要人物包括贾宝玉、林黛玉等', 38, 'FINISHED', '192.168.1.101', '2025-12-27 11:02:13', '2025-12-27 11:57:13', '2025-12-27 11:02:13', '2025-12-27 11:57:13');
INSERT INTO `exam_records` VALUES (11, 7, 5, '26:A;31:A,C,E;36:正确;41:施耐庵;46:《红楼梦》描写了四大家族的兴衰', 42, 'FINISHED', '192.168.1.102', '2025-12-27 11:02:13', '2025-12-27 12:00:13', '2025-12-27 11:02:13', '2025-12-27 12:00:13');
INSERT INTO `exam_records` VALUES (12, 7, 6, '26:C;31:A,B;36:正确;41:罗贯中;46:《红楼梦》很好', 35, 'FINISHED', '192.168.1.103', '2025-12-27 11:02:13', '2025-12-27 11:54:13', '2025-12-27 11:02:13', '2025-12-27 11:54:13');
INSERT INTO `exam_records` VALUES (13, 7, 7, '26:A;31:A,C,E;36:正确;41:施耐庵;46:《红楼梦》主要人物：1.贾宝玉：贾府的公子；2.林黛玉：贾府的外孙女；3.薛宝钗：贾府的表妹；4.王熙凤：贾府的管家', 48, 'FINISHED', '192.168.1.104', '2025-12-27 11:02:13', '2025-12-27 12:02:13', '2025-12-27 11:02:13', '2025-12-27 12:02:13');
INSERT INTO `exam_records` VALUES (14, 8, 4, '27:B;32:A,C,D;37:错误;42:2πr;47:一元二次方程ax²+bx+c=0的求根公式是x=(-b±√(b²-4ac))/(2a)', 40, 'FINISHED', '192.168.1.101', '2025-12-29 11:02:13', '2025-12-29 11:58:13', '2025-12-29 11:02:13', '2025-12-29 11:58:13');
INSERT INTO `exam_records` VALUES (15, 8, 5, '27:A;32:A,C,D;37:错误;42:2πr或πd;47:一元二次方程的判别式Δ=b²-4ac，当Δ>0时有两个不相等的实数根', 45, 'FINISHED', '192.168.1.102', '2025-12-29 11:02:13', '2025-12-29 12:01:13', '2025-12-29 11:02:13', '2025-12-29 12:01:13');
INSERT INTO `exam_records` VALUES (16, 8, 6, '27:C;32:A,B;37:正确;42:πr;47:一元二次方程很重要', 32, 'FINISHED', '192.168.1.103', '2025-12-29 11:02:13', '2025-12-29 11:52:13', '2025-12-29 11:02:13', '2025-12-29 11:52:13');
INSERT INTO `exam_records` VALUES (17, 8, 7, '27:A;32:A,C,D;37:错误;42:2πr或πd;47:一元二次方程ax²+bx+c=0（a≠0）的求根公式：x=(-b±√(b²-4ac))/(2a)。判别式Δ=b²-4ac：当Δ>0时有两个不相等的实数根；当Δ=0时有两个相等的实数根；当Δ<0时没有实数根', 50, 'FINISHED', '192.168.1.104', '2025-12-29 11:02:13', '2025-12-29 12:02:13', '2025-12-29 11:02:13', '2025-12-29 12:02:13');
INSERT INTO `exam_records` VALUES (18, 9, 4, '28:B;33:A,C,E;38:正确;43:book;48:英语时态分为现在时、过去时、将来时三大类', 38, 'FINISHED', '192.168.1.101', '2025-12-31 11:02:13', '2025-12-31 11:56:13', '2025-12-31 11:02:13', '2025-12-31 11:56:13');
INSERT INTO `exam_records` VALUES (19, 9, 5, '28:A;33:A,C,E;38:正确;43:book;48:英语时态包括一般现在时、现在进行时、现在完成时等', 43, 'FINISHED', '192.168.1.102', '2025-12-31 11:02:13', '2025-12-31 11:59:13', '2025-12-31 11:02:13', '2025-12-31 11:59:13');
INSERT INTO `exam_records` VALUES (20, 9, 6, '28:C;33:A,B;38:错误;43:read;48:英语时态很重要', 30, 'FINISHED', '192.168.1.103', '2025-12-31 11:02:13', '2025-12-31 11:50:13', '2025-12-31 11:02:13', '2025-12-31 11:50:13');
INSERT INTO `exam_records` VALUES (21, 9, 7, '28:A;33:A,C,E;38:正确;43:book;48:英语时态分为三大类：1.现在时：一般现在时、现在进行时、现在完成时；2.过去时：一般过去时、过去进行时、过去完成时；3.将来时：一般将来时、将来进行时', 47, 'FINISHED', '192.168.1.104', '2025-12-31 11:02:13', '2025-12-31 12:02:13', '2025-12-31 11:02:13', '2025-12-31 12:02:13');
INSERT INTO `exam_records` VALUES (22, 10, 4, '29:B;34:A,C,E;39:正确;44:米每秒平方或m/s²;49:能量守恒定律：能量既不会凭空产生，也不会凭空消失', 36, 'FINISHED', '192.168.1.101', '2026-01-02 11:02:13', '2026-01-02 11:55:13', '2026-01-02 11:02:13', '2026-01-02 11:55:13');
INSERT INTO `exam_records` VALUES (23, 10, 5, '29:B;34:A,C,E;39:正确;44:m/s²;49:能量守恒定律适用于所有自然现象，能量形式包括动能、势能等', 41, 'FINISHED', '192.168.1.102', '2026-01-02 11:02:13', '2026-01-02 11:58:13', '2026-01-02 11:02:13', '2026-01-02 11:58:13');
INSERT INTO `exam_records` VALUES (24, 10, 6, '29:A;34:A,B;39:错误;44:m/s;49:能量守恒定律很重要', 28, 'FINISHED', '192.168.1.103', '2026-01-02 11:02:13', '2026-01-02 11:47:13', '2026-01-02 11:02:13', '2026-01-02 11:47:13');
INSERT INTO `exam_records` VALUES (25, 10, 7, '29:B;34:A,C,E;39:正确;44:米每秒平方或m/s²;49:能量守恒定律：在一个孤立系统中，能量既不会凭空产生，也不会凭空消失，只能从一种形式转化为另一种形式，总量保持不变。能量形式包括：动能、势能、内能、化学能、电能等', 50, 'FINISHED', '192.168.1.104', '2026-01-02 11:02:13', '2026-01-02 12:02:13', '2026-01-02 11:02:13', '2026-01-02 12:02:13');
INSERT INTO `exam_records` VALUES (26, 4, 4, '4:D;9:A,B,D;14:正确;19:米每秒或m/s;24:牛顿三大运动定律：1.第一定律（惯性定律）；2.第二定律（加速度定律）F=ma；3.第三定律（作用与反作用定律）', 0, 'FINISHED', '0:0:0:0:0:0:0:1', '2026-01-06 15:22:15', '2026-01-06 15:39:26', '2026-01-06 15:22:15', '2026-01-06 15:39:26');

-- ----------------------------
-- Table structure for exams
-- ----------------------------
DROP TABLE IF EXISTS `exams`;
CREATE TABLE `exams`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `paper_id` bigint NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_time` datetime NULL DEFAULT NULL,
  `end_time` datetime NULL DEFAULT NULL,
  `duration` int NOT NULL,
  `token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `create_by` bigint NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `paper_id`(`paper_id` ASC) USING BTREE,
  CONSTRAINT `exams_ibfk_1` FOREIGN KEY (`paper_id`) REFERENCES `papers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exams
-- ----------------------------
INSERT INTO `exams` VALUES (1, '语文基础期末考试', '语文基础知识的期末考试，已结束', 1, 'FINISHED', '2025-12-30 11:02:13', '2025-12-31 11:02:13', 60, '19ec659d-eaac-11f0-80b5-30560f1f28a1', 2, '2025-12-29 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `exams` VALUES (2, '数学期中考试', '数学知识的期中考试，已结束', 2, 'FINISHED', '2026-01-01 11:02:13', '2026-01-02 11:02:13', 60, '19ec688b-eaac-11f0-80b5-30560f1f28a1', 2, '2025-12-31 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `exams` VALUES (3, '英语综合考试', '英语知识的综合考试，正在进行', 3, 'IN_PROGRESS', '2026-01-06 10:02:13', '2026-01-06 12:02:13', 60, '19ec690f-eaac-11f0-80b5-30560f1f28a1', 2, '2026-01-04 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `exams` VALUES (4, '物理综合考试', '物理知识的综合考试，正在进行', 4, 'IN_PROGRESS', '2026-01-06 10:32:13', '2026-01-06 12:02:13', 60, '19ec695a-eaac-11f0-80b5-30560f1f28a1', 2, '2026-01-05 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `exams` VALUES (5, '化学期末考试', '化学知识的期末考试，未开始', 5, 'NOT_STARTED', '2026-01-07 11:02:13', '2026-01-08 11:02:13', 60, '19ec69a1-eaac-11f0-80b5-30560f1f28a1', 2, '2026-01-05 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `exams` VALUES (6, '生物随机组卷考试', '使用随机组卷的生物考试，未开始', 6, 'NOT_STARTED', '2026-01-08 11:02:13', '2026-01-09 11:02:13', 60, '19ec69e8-eaac-11f0-80b5-30560f1f28a1', 2, '2026-01-05 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `exams` VALUES (7, '历史期末考试', '历史知识的期末考试，已结束', 9, 'FINISHED', '2025-12-27 11:02:13', '2025-12-28 11:02:13', 60, '19f2dbb5-eaac-11f0-80b5-30560f1f28a1', 2, '2025-12-26 11:02:13', '2025-12-28 11:02:13');
INSERT INTO `exams` VALUES (8, '地理综合考试', '地理知识的综合考试，已结束', 10, 'FINISHED', '2025-12-29 11:02:13', '2025-12-30 11:02:13', 60, '19f2ded4-eaac-11f0-80b5-30560f1f28a1', 2, '2025-12-28 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `exams` VALUES (9, '政治思想品德考试', '政治思想品德知识的考试，已结束', 11, 'FINISHED', '2025-12-31 11:02:13', '2026-01-01 11:02:13', 60, '19f2df5d-eaac-11f0-80b5-30560f1f28a1', 2, '2025-12-30 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `exams` VALUES (10, '综合实践活动考试', '综合实践活动知识的考试，已结束', 12, 'FINISHED', '2026-01-02 11:02:13', '2026-01-03 11:02:13', 60, '19f2dfb5-eaac-11f0-80b5-30560f1f28a1', 2, '2026-01-01 11:02:13', '2026-01-03 11:02:13');

-- ----------------------------
-- Table structure for papers
-- ----------------------------
DROP TABLE IF EXISTS `papers`;
CREATE TABLE `papers`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `total_score` int NULL DEFAULT NULL,
  `duration` int NULL DEFAULT NULL,
  `create_by` bigint NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of papers
-- ----------------------------
INSERT INTO `papers` VALUES (1, '语文基础测试卷', '包含语文基础知识的综合测试', 'FIXED', '1,6,11,16,21', 50, 60, 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `papers` VALUES (2, '数学综合测试卷', '数学相关知识综合测试', 'FIXED', '2,7,12,17,22', 50, 60, 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `papers` VALUES (3, '英语综合测试卷', '英语知识综合测试', 'FIXED', '3,8,13,18,23', 50, 60, 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `papers` VALUES (4, '物理综合测试卷', '物理相关知识综合测试', 'FIXED', '4,9,14,19,24', 50, 60, 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `papers` VALUES (5, '化学综合测试卷', '化学相关知识综合测试', 'FIXED', '5,10,15,20,25', 50, 60, 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `papers` VALUES (6, '随机试卷1', '通过智能算法生成的随机试卷', 'RANDOM', '1,7,12,18,22', 50, 60, 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `papers` VALUES (7, '随机试卷2', '通过智能算法生成的随机试卷', 'RANDOM', '2,8,13,19,23', 50, 60, 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `papers` VALUES (8, '历史综合测试卷', '历史相关知识综合测试', 'FIXED', '26,31,36,41,46', 50, 60, 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `papers` VALUES (9, '地理综合测试卷', '地理相关知识综合测试', 'FIXED', '27,32,37,42,47', 50, 60, 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `papers` VALUES (10, '政治思想品德测试卷', '政治思想品德知识综合测试', 'FIXED', '28,33,38,43,48', 50, 60, 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `papers` VALUES (11, '生物综合测试卷', '生物相关知识综合测试', 'FIXED', '29,34,39,44,49', 50, 60, 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `papers` VALUES (12, '综合实践活动测试卷', '综合实践活动相关知识测试', 'FIXED', '30,35,40,45,50', 50, 60, 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `papers` VALUES (13, '测试', '测试工会四合格', 'FIXED', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,115,16,17,18,19,20', 100, 120, NULL, '2026-01-06 16:25:11', NULL);
INSERT INTO `papers` VALUES (14, '随机试卷1', NULL, 'RANDOM', '40,45,17,5,44,14,42,43,2,38,41,16,39,3,30,29,36,27,18,28', 100, NULL, NULL, '2026-01-06 16:25:52', NULL);

-- ----------------------------
-- Table structure for questions
-- ----------------------------
DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `score` int NOT NULL,
  `difficulty` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `knowledge_point` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `create_by` bigint NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of questions
-- ----------------------------
INSERT INTO `questions` VALUES (1, 'SINGLE', '下列词语中，哪个是正确的成语？', 'A.一心一意\nB.一心一易\nC.一心意一\nD.一意一心', 'A', '一心一意是正确的成语，表示专注、专心致志。', 5, 'EASY', '语文基础知识', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (2, 'SINGLE', '下列哪个数是质数？', 'A.15\nB.17\nC.18\nD.21', 'B', '质数是只能被1和自身整除的数。17只能被1和17整除，是质数。', 5, 'MEDIUM', '数学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (3, 'SINGLE', '下列哪个单词的拼写是正确的？', 'A.recieve\nB.receive\nC.recive\nD.recieive', 'B', 'receive是正确的拼写，意思是接收、收到。', 5, 'MEDIUM', '英语词汇', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (4, 'SINGLE', '下列哪个物理量是标量？', 'A.速度\nB.加速度\nC.位移\nD.质量', 'D', '标量只有大小没有方向。质量只有大小，是标量；速度、加速度、位移既有大小又有方向，是矢量。', 5, 'EASY', '物理基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (5, 'SINGLE', '下列哪个是化学变化？', 'A.冰融化成水\nB.铁生锈\nC.玻璃破碎\nD.纸张折叠', 'B', '化学变化产生新物质。铁生锈是铁与氧气反应生成铁锈，产生了新物质，是化学变化。', 5, 'EASY', '化学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (6, 'MULTIPLE', '下列哪些是表示颜色的词语？', 'A.红色\nB.快乐\nC.蓝色\nD.绿色\nE.悲伤', 'A,C,D', '红色、蓝色、绿色都是表示颜色的词语。快乐和悲伤是表示情感的词语。', 10, 'MEDIUM', '语文词汇', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (7, 'MULTIPLE', '下列哪些是偶数？', 'A.2\nB.3\nC.4\nD.5\nE.6', 'A,C,E', '偶数是能被2整除的整数。2、4、6都能被2整除，是偶数。3和5不能被2整除，是奇数。', 10, 'MEDIUM', '数学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (8, 'MULTIPLE', '下列哪些是表示时间的英语单词？', 'A.morning\nB.happy\nC.afternoon\nD.good\nE.evening', 'A,C,E', 'morning（早晨）、afternoon（下午）、evening（晚上）都是表示时间的英语单词。happy和good是形容词。', 10, 'MEDIUM', '英语词汇', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (9, 'MULTIPLE', '下列哪些是力的作用效果？', 'A.改变物体的形状\nB.改变物体的运动状态\nC.改变物体的颜色\nD.使物体产生加速度\nE.改变物体的质量', 'A,B,D', '力的作用效果包括改变物体的形状和改变物体的运动状态（包括产生加速度）。颜色和质量不能通过力来改变。', 10, 'HARD', '物理基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (10, 'MULTIPLE', '下列哪些是化学单质？', 'A.氧气\nB.水\nC.铁\nD.氢气\nE.二氧化碳', 'A,C,D', '化学单质是由同一种元素组成的纯净物。氧气（O₂）、铁（Fe）、氢气（H₂）都是单质。水（H₂O）和二氧化碳（CO₂）是由不同元素组成的化合物，不是单质。', 10, 'EASY', '化学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (11, 'JUDGE', '《红楼梦》是中国古代四大名著之一。', NULL, '正确', '《红楼梦》、《西游记》、《水浒传》、《三国演义》是中国古代四大名著。', 5, 'EASY', '语文文学常识', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (12, 'JUDGE', '所有偶数的和都是偶数。', NULL, '正确', '偶数加偶数等于偶数，所以所有偶数的和仍然是偶数。', 5, 'MEDIUM', '数学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (13, 'JUDGE', '英语中，动词的第三人称单数形式通常在词尾加-s或-es。', NULL, '正确', '英语中，动词的第三人称单数形式通常在词尾加-s或-es，如he goes, she works等。', 5, 'MEDIUM', '英语语法', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (14, 'JUDGE', '物体做匀速直线运动时，受到的合外力为零。', NULL, '正确', '根据牛顿第一定律，物体做匀速直线运动时受到的合外力为零。如果合外力为零，物体将保持静止或匀速直线运动。', 5, 'EASY', '物理基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (15, 'JUDGE', '化学反应中，质量守恒定律适用于所有化学反应。', NULL, '正确', '质量守恒定律适用于所有化学反应，反应前后物质的总质量保持不变。', 5, 'MEDIUM', '化学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (16, 'FILL', '《静夜思》的作者是______。', NULL, '李白', '《静夜思》是唐代诗人李白的代表作之一，表达了对故乡的思念之情。', 5, 'EASY', '语文古诗词', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (17, 'FILL', '三角形的内角和等于______度。', NULL, '180', '三角形的三个内角之和始终等于180度，这是几何学的基本定理。', 5, 'EASY', '数学几何', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (18, 'FILL', '英语中，表示"早晨"的单词是______。', NULL, 'morning', 'morning是英语中表示"早晨"的单词，常用于问候如"Good morning"。', 5, 'EASY', '英语词汇', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (19, 'FILL', '物理学中，表示速度的单位是______。', NULL, '米每秒或m/s', '速度的单位是米每秒（m/s），表示物体在单位时间内移动的距离。', 5, 'MEDIUM', '物理基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (20, 'FILL', '化学中，水的化学式是______。', NULL, 'H2O', '水的化学式是H2O，表示一个水分子由两个氢原子和一个氧原子组成。', 5, 'EASY', '化学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (21, 'ESSAY', '请简述中国古代四大名著的作者和主要特点。', NULL, '中国古代四大名著包括：1.《红楼梦》作者曹雪芹，描写贾、史、王、薛四大家族的兴衰；2.《西游记》作者吴承恩，讲述唐僧师徒西天取经的故事；3.《水浒传》作者施耐庵，描写108位好汉聚义梁山的故事；4.《三国演义》作者罗贯中，描写三国时期的历史故事。', '四大名著是中国古典文学的巅峰之作，具有深刻的思想内涵和艺术价值。', 20, 'MEDIUM', '语文文学常识', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (22, 'ESSAY', '请说明勾股定理的内容和证明方法。', NULL, '勾股定理：在直角三角形中，两条直角边的平方和等于斜边的平方，即a²+b²=c²。证明方法：1.几何证明法（利用面积相等）；2.代数证明法（利用相似三角形）；3.向量证明法。勾股定理是几何学的重要定理，在数学和实际应用中都有广泛的应用。', '勾股定理是几何学的基础定理，有多种证明方法，体现了数学的美妙和严谨。', 20, 'MEDIUM', '数学几何', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (23, 'ESSAY', '请说明英语时态的分类和用法。', NULL, '英语时态分为现在时、过去时、将来时三大类，每类又分为一般、进行、完成、完成进行四种，共12种时态。1.一般现在时：表示习惯性动作或客观事实；2.现在进行时：表示正在进行的动作；3.现在完成时：表示已完成的动作对现在的影响；4.一般过去时：表示过去发生的动作；5.过去进行时：表示过去正在进行的动作；6.过去完成时：表示过去的过去发生的动作。', '英语时态是语法的重要组成部分，正确使用时态是准确表达时间关系的关键。', 20, 'HARD', '英语语法', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (24, 'ESSAY', '请说明牛顿三大运动定律的内容和应用。', NULL, '牛顿三大运动定律：1.第一定律（惯性定律）：物体在没有外力作用时，保持静止或匀速直线运动；2.第二定律（加速度定律）：F=ma，物体的加速度与合外力成正比，与质量成反比；3.第三定律（作用与反作用定律）：两个物体之间的作用力和反作用力大小相等、方向相反、作用在同一直线上。应用：解释各种运动现象，如汽车启动、刹车等。', '牛顿三大定律是经典力学的基础，解释了物体运动的基本规律。', 20, 'MEDIUM', '物理基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (25, 'ESSAY', '请说明化学反应的分类和特点。', NULL, '化学反应分类：1.按反应物和生成物类型：化合反应、分解反应、置换反应、复分解反应；2.按能量变化：吸热反应、放热反应；3.按是否可逆：可逆反应、不可逆反应；4.按反应速度：快速反应、慢速反应。特点：遵循质量守恒定律、能量守恒定律，有特定的反应条件（温度、压力、催化剂等）。', '化学反应的分类和特点是理解化学反应规律的基础。', 20, 'MEDIUM', '化学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (26, 'SINGLE', '《西游记》的作者是？', 'A.吴承恩\nB.施耐庵\nC.罗贯中\nD.曹雪芹', 'A', '《西游记》的作者是明代小说家吴承恩，描写了唐僧师徒西天取经的故事。', 5, 'MEDIUM', '语文文学常识', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (27, 'SINGLE', '下列哪个数能被3整除？', 'A.14\nB.15\nC.16\nD.17', 'B', '能被3整除的数各位数字之和能被3整除。15的各位数字之和是6，能被3整除，所以15能被3整除。', 5, 'EASY', '数学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (28, 'SINGLE', '英语中，表示"学生"的单词是？', 'A.teacher\nB.student\nC.school\nD.book', 'B', 'student是英语中表示"学生"的单词，teacher表示"老师"，school表示"学校"，book表示"书"。', 5, 'MEDIUM', '英语词汇', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (29, 'SINGLE', '物理学中，表示重力的字母是？', 'A.F\nB.G\nC.m\nD.a', 'B', 'G通常表示重力，F表示力，m表示质量，a表示加速度。', 5, 'MEDIUM', '物理基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (30, 'SINGLE', '化学中，表示氧气的化学式是？', 'A.H2O\nB.O2\nC.CO2\nD.N2', 'B', 'O2是氧气的化学式，表示一个氧气分子由两个氧原子组成。H2O是水，CO2是二氧化碳，N2是氮气。', 5, 'EASY', '化学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (31, 'MULTIPLE', '下列哪些是中国的传统节日？', 'A.春节\nB.圣诞节\nC.中秋节\nD.万圣节\nE.端午节', 'A,C,E', '春节、中秋节、端午节都是中国的传统节日。圣诞节和万圣节是西方节日。', 10, 'MEDIUM', '语文文化常识', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (32, 'MULTIPLE', '下列哪些是质数？', 'A.2\nB.4\nC.5\nD.7\nE.9', 'A,C,D', '质数是只能被1和自身整除的数。2、5、7都是质数。4和9能被其他数整除，不是质数。', 10, 'MEDIUM', '数学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (33, 'MULTIPLE', '下列哪些是英语中的颜色单词？', 'A.red\nB.happy\nC.blue\nD.sad\nE.green', 'A,C,E', 'red（红色）、blue（蓝色）、green（绿色）都是颜色单词。happy和sad是情感单词。', 10, 'MEDIUM', '英语词汇', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (34, 'MULTIPLE', '下列哪些是物理量？', 'A.速度\nB.颜色\nC.质量\nD.味道\nE.时间', 'A,C,E', '速度、质量、时间都是物理量，可以用数值和单位表示。颜色和味道不是物理量。', 10, 'MEDIUM', '物理基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (35, 'MULTIPLE', '下列哪些是化学元素的符号？', 'A.Fe\nB.H₂O\nC.O\nD.Na\nE.CO₂', 'A,C,D', 'Fe（铁）、O（氧）、Na（钠）都是化学元素符号。H₂O是水的化学式，CO₂是二氧化碳的化学式，它们是化合物，不是元素符号。', 10, 'MEDIUM', '化学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (36, 'JUDGE', '0是最小的自然数。', NULL, '正确', '在数学中，0是最小的自然数。自然数从0开始，即0, 1, 2, 3, ...', 5, 'MEDIUM', '数学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (37, 'JUDGE', '英语中，所有动词的过去式都在词尾加-ed。', NULL, '错误', '英语中，有些动词的过去式是规则变化（加-ed），但还有很多动词是不规则变化，如go-went、see-saw等。', 5, 'MEDIUM', '英语语法', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (38, 'JUDGE', '物体在真空中下落时，所有物体下落速度相同。', NULL, '正确', '在真空中，不考虑空气阻力，所有物体无论质量大小，下落速度都相同。这是伽利略的实验结论。', 5, 'MEDIUM', '物理基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (39, 'JUDGE', '化学反应中，反应物的总质量等于生成物的总质量。', NULL, '正确', '根据质量守恒定律，化学反应前后物质的总质量保持不变，反应物的总质量等于生成物的总质量。', 5, 'MEDIUM', '化学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (40, 'JUDGE', '生物细胞是生物体的基本结构和功能单位。', NULL, '正确', '细胞学说认为，细胞是生物体的基本结构和功能单位，所有生物都由细胞构成。', 5, 'EASY', '生物基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (41, 'FILL', '《水浒传》的作者是______。', NULL, '施耐庵', '《水浒传》的作者是元末明初小说家施耐庵，描写了108位好汉聚义梁山的故事。', 5, 'MEDIUM', '语文文学常识', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (42, 'FILL', '圆的周长公式是C=______。', NULL, '2πr或πd', '圆的周长公式是C=2πr（r为半径）或C=πd（d为直径）。', 5, 'EASY', '数学几何', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (43, 'FILL', '英语中，表示"书"的单词是______。', NULL, 'book', 'book是英语中表示"书"的单词，是一个常用的基础词汇。', 5, 'MEDIUM', '英语词汇', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (44, 'FILL', '物理学中，表示加速度的单位是______。', NULL, '米每秒平方或m/s²', '加速度的单位是米每秒平方（m/s²），表示速度在单位时间内的变化率。', 5, 'MEDIUM', '物理基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (45, 'FILL', '化学中，表示二氧化碳的化学式是______。', NULL, 'CO2', 'CO2是二氧化碳的化学式，表示一个二氧化碳分子由一个碳原子和两个氧原子组成。', 5, 'EASY', '化学基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (46, 'ESSAY', '请说明《红楼梦》的主要人物和故事情节。', NULL, '《红楼梦》主要人物：1.贾宝玉：贾府的公子，痴情于林黛玉；2.林黛玉：贾府的外孙女，才华横溢但体弱多病；3.薛宝钗：贾府的表妹，端庄贤淑；4.王熙凤：贾府的管家，精明能干。主要情节：描写了贾、史、王、薛四大家族的兴衰，以贾宝玉和林黛玉的爱情悲剧为主线，反映了封建社会的衰落。', '《红楼梦》是中国古典文学的巅峰之作，深刻反映了封建社会的兴衰和人性。', 20, 'MEDIUM', '语文文学常识', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (47, 'ESSAY', '请说明一元二次方程的求根公式和应用。', NULL, '一元二次方程ax²+bx+c=0（a≠0）的求根公式：x=(-b±√(b²-4ac))/(2a)。判别式Δ=b²-4ac：1.当Δ>0时，方程有两个不相等的实数根；2.当Δ=0时，方程有两个相等的实数根；3.当Δ<0时，方程没有实数根。应用：解决实际问题中的方程问题，如面积计算、运动问题等。', '一元二次方程是数学中的重要内容，求根公式是解决这类方程的标准方法。', 20, 'HARD', '数学代数', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (48, 'ESSAY', '请说明英语时态的分类和基本用法。', NULL, '英语时态分为三大类：1.现在时：一般现在时（表示习惯、事实）、现在进行时（表示正在进行的动作）、现在完成时（表示已完成的动作对现在的影响）；2.过去时：一般过去时（表示过去的动作）、过去进行时（表示过去正在进行的动作）、过去完成时（表示过去的过去）；3.将来时：一般将来时（表示将来的动作）、将来进行时（表示将来正在进行的动作）。', '英语时态是语法的基础，正确使用时态是准确表达时间关系的关键。', 20, 'HARD', '英语语法', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (49, 'ESSAY', '请说明能量守恒定律的内容和应用。', NULL, '能量守恒定律：在一个孤立系统中，能量既不会凭空产生，也不会凭空消失，只能从一种形式转化为另一种形式，总量保持不变。能量形式包括：动能、势能、内能、化学能、电能等。应用：1.解释各种物理现象，如机械能守恒、热力学第一定律；2.解决实际问题，如能源利用、效率计算；3.理解自然界的基本规律。', '能量守恒定律是物理学的基本定律之一，适用于所有自然现象。', 20, 'HARD', '物理基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `questions` VALUES (50, 'ESSAY', '请说明光合作用的过程和意义。', NULL, '光合作用过程：植物利用光能、二氧化碳和水，在叶绿体中合成有机物（如葡萄糖）并释放氧气。化学反应式：6CO2+6H2O→C6H12O6+6O2。意义：1.是地球上所有生物能量和有机物的来源；2.维持大气中氧气和二氧化碳的平衡；3.是生态系统中物质循环的基础；4.对地球环境具有重要意义。', '光合作用是生物圈的基础过程，对维持地球生态平衡具有重要意义。', 20, 'MEDIUM', '生物基础', 2, '2026-01-06 11:02:13', '2026-01-06 11:02:13');

-- ----------------------------
-- Table structure for scores
-- ----------------------------
DROP TABLE IF EXISTS `scores`;
CREATE TABLE `scores`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `exam_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  `question_id` bigint NOT NULL,
  `student_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `correct_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `score` int NULL DEFAULT NULL,
  `full_score` int NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `exam_id`(`exam_id` ASC) USING BTREE,
  INDEX `student_id`(`student_id` ASC) USING BTREE,
  INDEX `question_id`(`question_id` ASC) USING BTREE,
  CONSTRAINT `scores_ibfk_1` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_ibfk_3` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 106 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scores
-- ----------------------------
INSERT INTO `scores` VALUES (1, 1, 4, 1, 'A', 'A', 5, 5, 'CORRECT', NULL, '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (2, 1, 4, 6, 'A,C', 'A,C,D', 0, 10, 'WRONG', NULL, '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (3, 1, 4, 11, '正确', '正确', 5, 5, 'CORRECT', NULL, '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (4, 1, 4, 16, '李白', '李白', 5, 5, 'CORRECT', NULL, '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (5, 1, 4, 21, '中国古代四大名著包括《红楼梦》、《西游记》、《水浒传》、《三国演义》', '中国古代四大名著包括：1.《红楼梦》作者曹雪芹，描写贾、史、王、薛四大家族的兴衰；2.《西游记》作者吴承恩，讲述唐僧师徒西天取经的故事；3.《水浒传》作者施耐庵，描写108位好汉聚义梁山的故事；4.《三国演义》作者罗贯中，描写三国时期的历史故事。', 18, 20, 'GRADED', '回答较为完整，但可以更详细', '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (6, 1, 5, 1, 'A', 'A', 5, 5, 'CORRECT', NULL, '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (7, 1, 5, 6, 'A,C,D', 'A,C,D', 10, 10, 'CORRECT', NULL, '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (8, 1, 5, 11, '正确', '正确', 5, 5, 'CORRECT', NULL, '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (9, 1, 5, 16, '李白', '李白', 5, 5, 'CORRECT', NULL, '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (10, 1, 5, 21, '四大名著包括《红楼梦》作者曹雪芹、《西游记》作者吴承恩等', '中国古代四大名著包括：1.《红楼梦》作者曹雪芹，描写贾、史、王、薛四大家族的兴衰；2.《西游记》作者吴承恩，讲述唐僧师徒西天取经的故事；3.《水浒传》作者施耐庵，描写108位好汉聚义梁山的故事；4.《三国演义》作者罗贯中，描写三国时期的历史故事。', 15, 20, 'GRADED', '回答不够全面，需要补充更多内容', '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (11, 1, 6, 1, 'B', 'A', 0, 5, 'WRONG', NULL, '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (12, 1, 6, 6, 'A,C', 'A,C,D', 0, 10, 'WRONG', NULL, '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (13, 1, 6, 11, '错误', '正确', 0, 5, 'WRONG', NULL, '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (14, 1, 6, 16, '杜甫', '李白', 0, 5, 'WRONG', NULL, '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (15, 1, 6, 21, '四大名著很好', '中国古代四大名著包括：1.《红楼梦》作者曹雪芹，描写贾、史、王、薛四大家族的兴衰；2.《西游记》作者吴承恩，讲述唐僧师徒西天取经的故事；3.《水浒传》作者施耐庵，描写108位好汉聚义梁山的故事；4.《三国演义》作者罗贯中，描写三国时期的历史故事。', 5, 20, 'GRADED', '回答过于简单，需要详细说明', '2025-12-30 11:02:13', '2025-12-30 11:02:13');
INSERT INTO `scores` VALUES (16, 2, 4, 2, 'A', 'A', 5, 5, 'CORRECT', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (17, 2, 4, 7, 'A,B,C', 'A,B,C,D', 0, 10, 'WRONG', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (18, 2, 4, 12, '正确', '正确', 5, 5, 'CORRECT', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (19, 2, 4, 17, '180', '180', 5, 5, 'CORRECT', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (20, 2, 4, 22, '勾股定理是a²+b²=c²，可以用几何法证明', '勾股定理：在直角三角形中，两条直角边的平方和等于斜边的平方，即a²+b²=c²。证明方法：1.几何证明法（利用面积相等）；2.代数证明法（利用相似三角形）；3.向量证明法。勾股定理是几何学的重要定理，在数学和实际应用中都有广泛的应用。', 16, 20, 'GRADED', '回答正确但不够详细', '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (21, 2, 5, 2, 'A', 'A', 5, 5, 'CORRECT', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (22, 2, 5, 7, 'A,B,C,D', 'A,B,C,D', 10, 10, 'CORRECT', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (23, 2, 5, 12, '正确', '正确', 5, 5, 'CORRECT', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (24, 2, 5, 17, '180', '180', 5, 5, 'CORRECT', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (25, 2, 5, 22, '勾股定理在直角三角形中成立', '勾股定理：在直角三角形中，两条直角边的平方和等于斜边的平方，即a²+b²=c²。证明方法：1.几何证明法（利用面积相等）；2.代数证明法（利用相似三角形）；3.向量证明法。勾股定理是几何学的重要定理，在数学和实际应用中都有广泛的应用。', 12, 20, 'GRADED', '回答过于简单，需要补充更多内容', '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (26, 2, 6, 2, 'B', 'A', 0, 5, 'WRONG', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (27, 2, 6, 7, 'A,B', 'A,B,C,D', 0, 10, 'WRONG', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (28, 2, 6, 12, '错误', '正确', 0, 5, 'WRONG', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (29, 2, 6, 17, '90', '180', 0, 5, 'WRONG', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (30, 2, 6, 22, '勾股定理很重要', '勾股定理：在直角三角形中，两条直角边的平方和等于斜边的平方，即a²+b²=c²。证明方法：1.几何证明法（利用面积相等）；2.代数证明法（利用相似三角形）；3.向量证明法。勾股定理是几何学的重要定理，在数学和实际应用中都有广泛的应用。', 8, 20, 'GRADED', '回答不完整，需要详细说明', '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (31, 2, 7, 2, 'A', 'A', 5, 5, 'CORRECT', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (32, 2, 7, 7, 'A,B,C,D', 'A,B,C,D', 10, 10, 'CORRECT', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (33, 2, 7, 12, '正确', '正确', 5, 5, 'CORRECT', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (34, 2, 7, 17, '180', '180', 5, 5, 'CORRECT', NULL, '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (35, 2, 7, 22, '勾股定理：在直角三角形中，两条直角边的平方和等于斜边的平方，即a²+b²=c²。证明方法：1.几何证明法（利用面积相等）；2.代数证明法（利用相似三角形）；3.向量证明法', '勾股定理：在直角三角形中，两条直角边的平方和等于斜边的平方，即a²+b²=c²。证明方法：1.几何证明法（利用面积相等）；2.代数证明法（利用相似三角形）；3.向量证明法。勾股定理是几何学的重要定理，在数学和实际应用中都有广泛的应用。', 20, 20, 'GRADED', '回答完整准确，优秀', '2026-01-01 11:02:13', '2026-01-01 11:02:13');
INSERT INTO `scores` VALUES (36, 7, 4, 26, 'B', 'B', 5, 5, 'CORRECT', NULL, '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (37, 7, 4, 31, 'A,B', 'A,B,C,D', 0, 10, 'WRONG', NULL, '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (38, 7, 4, 36, '错误', '正确', 0, 5, 'WRONG', NULL, '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (39, 7, 4, 41, '施耐庵', '施耐庵', 5, 5, 'CORRECT', NULL, '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (40, 7, 4, 46, '《红楼梦》主要人物包括贾宝玉、林黛玉等', '《红楼梦》主要人物：1.贾宝玉：贾府的公子，痴情于林黛玉；2.林黛玉：贾府的外孙女，才华横溢但体弱多病；3.薛宝钗：贾府的表妹，端庄贤淑；4.王熙凤：贾府的管家，精明能干。主要情节：描写了贾、史、王、薛四大家族的兴衰，以贾宝玉和林黛玉的爱情悲剧为主线，反映了封建社会的衰落。', 15, 20, 'GRADED', '回答不够全面', '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (41, 7, 5, 26, 'A', 'B', 0, 5, 'WRONG', NULL, '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (42, 7, 5, 31, 'A,B,C', 'A,B,C,D', 0, 10, 'WRONG', NULL, '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (43, 7, 5, 36, '正确', '正确', 5, 5, 'CORRECT', NULL, '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (44, 7, 5, 41, '施耐庵', '施耐庵', 5, 5, 'CORRECT', NULL, '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (45, 7, 5, 46, '《红楼梦》描写了四大家族的兴衰', '《红楼梦》主要人物：1.贾宝玉：贾府的公子，痴情于林黛玉；2.林黛玉：贾府的外孙女，才华横溢但体弱多病；3.薛宝钗：贾府的表妹，端庄贤淑；4.王熙凤：贾府的管家，精明能干。主要情节：描写了贾、史、王、薛四大家族的兴衰，以贾宝玉和林黛玉的爱情悲剧为主线，反映了封建社会的衰落。', 10, 20, 'GRADED', '回答过于简单', '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (46, 7, 6, 26, 'C', 'B', 0, 5, 'WRONG', NULL, '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (47, 7, 6, 31, 'A,B', 'A,B,C,D', 0, 10, 'WRONG', NULL, '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (48, 7, 6, 36, '正确', '正确', 5, 5, 'CORRECT', NULL, '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (49, 7, 6, 41, '罗贯中', '施耐庵', 0, 5, 'WRONG', NULL, '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (50, 7, 6, 46, '《红楼梦》很好', '《红楼梦》主要人物：1.贾宝玉：贾府的公子，痴情于林黛玉；2.林黛玉：贾府的外孙女，才华横溢但体弱多病；3.薛宝钗：贾府的表妹，端庄贤淑；4.王熙凤：贾府的管家，精明能干。主要情节：描写了贾、史、王、薛四大家族的兴衰，以贾宝玉和林黛玉的爱情悲剧为主线，反映了封建社会的衰落。', 8, 20, 'GRADED', '回答过于简单', '2025-12-27 11:02:13', '2025-12-27 11:02:13');
INSERT INTO `scores` VALUES (51, 8, 4, 27, 'B', 'A', 0, 5, 'WRONG', NULL, '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (52, 8, 4, 32, 'A,B,C', 'A,B,C,D', 0, 10, 'WRONG', NULL, '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (53, 8, 4, 37, '正确', '错误', 0, 5, 'WRONG', NULL, '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (54, 8, 4, 42, '2πr', '2πr或πd', 5, 5, 'CORRECT', NULL, '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (55, 8, 4, 47, '一元二次方程ax²+bx+c=0的求根公式是x=(-b±√(b²-4ac))/(2a)', '一元二次方程ax²+bx+c=0（a≠0）的求根公式：x=(-b±√(b²-4ac))/(2a)。判别式Δ=b²-4ac：1.当Δ>0时，方程有两个不相等的实数根；2.当Δ=0时，方程有两个相等的实数根；3.当Δ<0时，方程没有实数根。应用：解决实际问题中的方程问题，如面积计算、运动问题等。', 12, 20, 'GRADED', '回答不完整', '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (56, 8, 5, 27, 'A', 'A', 5, 5, 'CORRECT', NULL, '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (57, 8, 5, 32, 'A,B,C,D', 'A,B,C,D', 10, 10, 'CORRECT', NULL, '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (58, 8, 5, 37, '错误', '错误', 5, 5, 'CORRECT', NULL, '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (59, 8, 5, 42, '2πr或πd', '2πr或πd', 5, 5, 'CORRECT', NULL, '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (60, 8, 5, 47, '一元二次方程的判别式Δ=b²-4ac，当Δ>0时有两个不相等的实数根', '一元二次方程ax²+bx+c=0（a≠0）的求根公式：x=(-b±√(b²-4ac))/(2a)。判别式Δ=b²-4ac：1.当Δ>0时，方程有两个不相等的实数根；2.当Δ=0时，方程有两个相等的实数根；3.当Δ<0时，方程没有实数根。应用：解决实际问题中的方程问题，如面积计算、运动问题等。', 15, 20, 'GRADED', '回答正确但可以更详细', '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (61, 8, 6, 27, 'C', 'A', 0, 5, 'WRONG', NULL, '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (62, 8, 6, 32, 'A,B', 'A,B,C,D', 0, 10, 'WRONG', NULL, '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (63, 8, 6, 37, '正确', '错误', 0, 5, 'WRONG', NULL, '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (64, 8, 6, 42, 'πr', '2πr或πd', 0, 5, 'WRONG', NULL, '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (65, 8, 6, 47, '一元二次方程很重要', '一元二次方程ax²+bx+c=0（a≠0）的求根公式：x=(-b±√(b²-4ac))/(2a)。判别式Δ=b²-4ac：1.当Δ>0时，方程有两个不相等的实数根；2.当Δ=0时，方程有两个相等的实数根；3.当Δ<0时，方程没有实数根。应用：解决实际问题中的方程问题，如面积计算、运动问题等。', 5, 20, 'GRADED', '回答错误', '2025-12-29 11:02:13', '2025-12-29 11:02:13');
INSERT INTO `scores` VALUES (66, 9, 4, 28, 'B', 'A', 0, 5, 'WRONG', NULL, '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (67, 9, 4, 33, 'A,B,C', 'A,B,C,D', 0, 10, 'WRONG', NULL, '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (68, 9, 4, 38, '错误', '正确', 0, 5, 'WRONG', NULL, '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (69, 9, 4, 43, 'book', 'book', 5, 5, 'CORRECT', NULL, '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (70, 9, 4, 48, '英语时态分为现在时、过去时、将来时三大类', '英语时态分为三大类：1.现在时：一般现在时（表示习惯、事实）、现在进行时（表示正在进行的动作）、现在完成时（表示已完成的动作对现在的影响）；2.过去时：一般过去时（表示过去的动作）、过去进行时（表示过去正在进行的动作）、过去完成时（表示过去的过去）；3.将来时：一般将来时（表示将来的动作）、将来进行时（表示将来正在进行的动作）。', 16, 20, 'GRADED', '回答不够详细', '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (71, 9, 5, 28, 'A', 'A', 5, 5, 'CORRECT', NULL, '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (72, 9, 5, 33, 'A,B,C,D', 'A,B,C,D', 10, 10, 'CORRECT', NULL, '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (73, 9, 5, 38, '正确', '正确', 5, 5, 'CORRECT', NULL, '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (74, 9, 5, 43, 'read', 'book', 0, 5, 'WRONG', NULL, '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (75, 9, 5, 48, '英语时态包括一般现在时、现在进行时、现在完成时等', '英语时态分为三大类：1.现在时：一般现在时（表示习惯、事实）、现在进行时（表示正在进行的动作）、现在完成时（表示已完成的动作对现在的影响）；2.过去时：一般过去时（表示过去的动作）、过去进行时（表示过去正在进行的动作）、过去完成时（表示过去的过去）；3.将来时：一般将来时（表示将来的动作）、将来进行时（表示将来正在进行的动作）。', 12, 20, 'GRADED', '回答过于简单', '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (76, 9, 6, 28, 'C', 'A', 0, 5, 'WRONG', NULL, '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (77, 9, 6, 33, 'A,B', 'A,B,C,D', 0, 10, 'WRONG', NULL, '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (78, 9, 6, 38, '错误', '正确', 0, 5, 'WRONG', NULL, '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (79, 9, 6, 43, 'read', 'book', 0, 5, 'WRONG', NULL, '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (80, 9, 6, 48, '英语时态很重要', '英语时态分为三大类：1.现在时：一般现在时（表示习惯、事实）、现在进行时（表示正在进行的动作）、现在完成时（表示已完成的动作对现在的影响）；2.过去时：一般过去时（表示过去的动作）、过去进行时（表示过去正在进行的动作）、过去完成时（表示过去的过去）；3.将来时：一般将来时（表示将来的动作）、将来进行时（表示将来正在进行的动作）。', 5, 20, 'GRADED', '回答过于简单', '2025-12-31 11:02:13', '2025-12-31 11:02:13');
INSERT INTO `scores` VALUES (81, 10, 4, 29, 'C', 'A', 0, 5, 'WRONG', NULL, '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (82, 10, 4, 34, 'A,B,C', 'A,B,C,D', 0, 10, 'WRONG', NULL, '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (83, 10, 4, 39, '正确', '正确', 5, 5, 'CORRECT', NULL, '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (84, 10, 4, 44, '米每秒平方或m/s²', '米每秒平方或m/s²', 5, 5, 'CORRECT', NULL, '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (85, 10, 4, 49, '能量守恒定律：能量既不会凭空产生，也不会凭空消失', '能量守恒定律：在一个孤立系统中，能量既不会凭空产生，也不会凭空消失，只能从一种形式转化为另一种形式，总量保持不变。能量形式包括：动能、势能、内能、化学能、电能等。应用：1.解释各种物理现象，如机械能守恒、热力学第一定律；2.解决实际问题，如能源利用、效率计算；3.理解自然界的基本规律。', 10, 20, 'GRADED', '回答不够详细', '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (86, 10, 5, 29, 'A', 'A', 5, 5, 'CORRECT', NULL, '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (87, 10, 5, 34, 'A,B,C,D', 'A,B,C,D', 10, 10, 'CORRECT', NULL, '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (88, 10, 5, 39, '正确', '正确', 5, 5, 'CORRECT', NULL, '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (89, 10, 5, 44, 'm/s²', '米每秒平方或m/s²', 5, 5, 'CORRECT', NULL, '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (90, 10, 5, 49, '能量守恒定律适用于所有自然现象，能量形式包括动能、势能等', '能量守恒定律：在一个孤立系统中，能量既不会凭空产生，也不会凭空消失，只能从一种形式转化为另一种形式，总量保持不变。能量形式包括：动能、势能、内能、化学能、电能等。应用：1.解释各种物理现象，如机械能守恒、热力学第一定律；2.解决实际问题，如能源利用、效率计算；3.理解自然界的基本规律。', 12, 20, 'GRADED', '回答不够全面', '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (91, 10, 6, 29, 'B', 'A', 0, 5, 'WRONG', NULL, '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (92, 10, 6, 34, 'A,B', 'A,B,C,D', 0, 10, 'WRONG', NULL, '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (93, 10, 6, 39, '错误', '正确', 0, 5, 'WRONG', NULL, '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (94, 10, 6, 44, 'm/s', '米每秒平方或m/s²', 0, 5, 'WRONG', NULL, '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (95, 10, 6, 49, '能量守恒定律很重要', '能量守恒定律：在一个孤立系统中，能量既不会凭空产生，也不会凭空消失，只能从一种形式转化为另一种形式，总量保持不变。能量形式包括：动能、势能、内能、化学能、电能等。应用：1.解释各种物理现象，如机械能守恒、热力学第一定律；2.解决实际问题，如能源利用、效率计算；3.理解自然界的基本规律。', 5, 20, 'GRADED', '回答错误', '2026-01-02 11:02:13', '2026-01-02 11:02:13');
INSERT INTO `scores` VALUES (96, 4, 4, 19, '米每秒或m/s', '米每秒或m/s', 5, 5, 'CORRECT', NULL, '2026-01-06 15:39:26', '2026-01-06 15:39:26');
INSERT INTO `scores` VALUES (97, 4, 4, 4, 'B.INSERT', 'A', 0, 5, 'WRONG', NULL, '2026-01-06 15:39:26', '2026-01-06 15:39:26');
INSERT INTO `scores` VALUES (98, 4, 4, 24, '牛顿三大运动定律：1.第一定律（惯性定律）；2.第二定律（加速度定律）F=ma；3.第三定律（作用与反作用定律）', '牛顿三大运动定律：1.第一定律（惯性定律）：物体在没有外力作用时，保持静止或匀速直线运动；2.第二定律（加速度定律）：F=ma，物体的加速度与合外力成正比，与质量成反比；3.第三定律（作用与反作用定律）：两个物体之间的作用力和反作用力大小相等、方向相反、作用在同一直线上。应用：解释各种运动现象，如汽车启动、刹车等。', 15, 20, 'GRADED', '回答基本正确，但可以更详细', '2026-01-06 15:39:26', '2026-01-06 15:39:26');
INSERT INTO `scores` VALUES (99, 4, 4, 9, 'A.改变物体的形状,B.改变物体的运动状态,D.使物体产生加速度', 'A,B,D', 10, 10, 'CORRECT', NULL, '2026-01-06 15:39:26', '2026-01-06 15:39:26');
INSERT INTO `scores` VALUES (100, 4, 4, 14, '正确', '错误', 0, 5, 'WRONG', NULL, '2026-01-06 15:39:26', '2026-01-06 15:39:26');
INSERT INTO `scores` VALUES (101, 3, 4, 18, 'morning', 'morning', 5, 5, 'CORRECT', NULL, '2026-01-06 16:27:14', '2026-01-06 16:27:14');
INSERT INTO `scores` VALUES (102, 3, 4, 3, 'C.both A and B', 'C', 0, 5, 'WRONG', NULL, '2026-01-06 16:27:14', '2026-01-06 16:27:14');
INSERT INTO `scores` VALUES (103, 3, 4, 23, '英语时态分为现在时、过去时、将来时三大类', '英语时态分为现在时、过去时、将来时三大类，每类又分为一般、进行、完成、完成进行四种，共12种时态。1.一般现在时：表示习惯性动作或客观事实；2.现在进行时：表示正在进行的动作；3.现在完成时：表示已完成的动作对现在的影响；4.一般过去时：表示过去发生的动作；5.过去进行时：表示过去正在进行的动作；6.过去完成时：表示过去的过去发生的动作。', 12, 20, 'GRADED', '回答基本正确，但可以更详细', '2026-01-06 16:27:14', '2026-01-06 16:27:14');
INSERT INTO `scores` VALUES (104, 3, 4, 8, 'A.morning,C.afternoon,E.evening', 'A,C,E', 10, 10, 'CORRECT', NULL, '2026-01-06 16:27:14', '2026-01-06 16:27:14');
INSERT INTO `scores` VALUES (105, 3, 4, 13, '正确', '正确', 5, 5, 'CORRECT', NULL, '2026-01-06 16:27:14', '2026-01-06 16:27:14');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `real_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', '123456', '系统管理员', 'ADMIN', 'admin@school.edu.cn', '13800001001', '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `users` VALUES (2, 'teacher1', '123456', '张老师', 'TEACHER', 'teacher1@school.edu.cn', '13800002001', '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `users` VALUES (3, 'teacher2', '123456', '李老师', 'TEACHER', 'teacher2@school.edu.cn', '13800002002', '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `users` VALUES (4, 'student1', '123456', '王同学', 'STUDENT', 'student1@school.edu.cn', '13800003001', '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `users` VALUES (5, 'student2', '123456', '赵同学', 'STUDENT', 'student2@school.edu.cn', '13800003002', '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `users` VALUES (6, 'student3', '123456', '钱同学', 'STUDENT', 'student3@school.edu.cn', '13800003003', '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `users` VALUES (7, 'student4', '123456', '孙同学', 'STUDENT', 'student4@school.edu.cn', '13800003004', '2026-01-06 11:02:13', '2026-01-06 11:02:13');
INSERT INTO `users` VALUES (8, 'student5', '123456', '周同学', 'STUDENT', 'student5@school.edu.cn', '13800003005', '2026-01-06 11:02:13', '2026-01-06 11:02:13');

SET FOREIGN_KEY_CHECKS = 1;
