package com.exam.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Service
public class FileService {

    @Value("${file.upload-path}")
    private String uploadPath;

    public String uploadFile(MultipartFile file, String subFolder) throws IOException {
        if (file.isEmpty()) {
            throw new RuntimeException("文件为空");
        }

        // 创建上传目录
        String folder = uploadPath + File.separator + subFolder;
        File dir = new File(folder);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        // 生成唯一文件名
        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        String filename = UUID.randomUUID().toString() + extension;
        String dateFolder = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String finalPath = folder + File.separator + dateFolder;
        
        File dateDir = new File(finalPath);
        if (!dateDir.exists()) {
            dateDir.mkdirs();
        }

        // 保存文件
        Path path = Paths.get(finalPath, filename);
        Files.write(path, file.getBytes());

        // 返回相对路径（用于访问）
        return "/uploads/" + subFolder + "/" + dateFolder + "/" + filename;
    }

    public File getFile(String filePath) {
        String fullPath = uploadPath + filePath.replace("/uploads", "");
        File file = new File(fullPath);
        if (file.exists()) {
            return file;
        }
        return null;
    }

    public boolean deleteFile(String filePath) {
        String fullPath = uploadPath + filePath.replace("/uploads", "");
        File file = new File(fullPath);
        if (file.exists()) {
            return file.delete();
        }
        return false;
    }
}

