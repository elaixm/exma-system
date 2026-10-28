package com.exam.controller;

import com.exam.common.Result;
import com.exam.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;

@RestController
@RequestMapping("/files")
public class FileController {

    @Autowired
    private FileService fileService;

    @PostMapping("/upload")
    public Result<String> uploadFile(@RequestParam("file") MultipartFile file,
                                     @RequestParam(value = "folder", defaultValue = "common") String folder) {
        try {
            String filePath = fileService.uploadFile(file, folder);
            return Result.success(filePath);
        } catch (Exception e) {
            return Result.error("文件上传失败: " + e.getMessage());
        }
    }

    @GetMapping("/download")
    public ResponseEntity<Resource> downloadFile(@RequestParam String path) {
        try {
            File file = fileService.getFile(path);
            if (file == null || !file.exists()) {
                return ResponseEntity.notFound().build();
            }

            Resource resource = new FileSystemResource(file);
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getName() + "\"")
                    .body(resource);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/view")
    public ResponseEntity<Resource> viewFile(@RequestParam String path) {
        try {
            File file = fileService.getFile(path);
            if (file == null || !file.exists()) {
                return ResponseEntity.notFound().build();
            }

            Resource resource = new FileSystemResource(file);
            String contentType = "application/octet-stream";
            String filename = file.getName().toLowerCase();
            if (filename.endsWith(".jpg") || filename.endsWith(".jpeg")) {
                contentType = "image/jpeg";
            } else if (filename.endsWith(".png")) {
                contentType = "image/png";
            } else if (filename.endsWith(".gif")) {
                contentType = "image/gif";
            } else if (filename.endsWith(".pdf")) {
                contentType = "application/pdf";
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(resource);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/delete")
    public Result<Void> deleteFile(@RequestParam String path) {
        try {
            boolean deleted = fileService.deleteFile(path);
            if (deleted) {
                return Result.success("删除成功", null);
            } else {
                return Result.error("文件不存在或删除失败");
            }
        } catch (Exception e) {
            return Result.error("删除失败: " + e.getMessage());
        }
    }
}

