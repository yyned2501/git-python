# 使用官方的 Python 基础镜像  
FROM python

# 设置工作目录  
WORKDIR /app

# 将文件复制到镜像中  
COPY docker-entrypoint.sh .  

# 运行一个示例命令（可选）  
CMD ["bash", "docker-entrypoint.sh"]