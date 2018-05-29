# docker-development

## Description

This repository is to host Dockerfile for different purposes.
The base image is Ubuntu 16.04,
The installed software development packages are:
1. Git
2. SQLite 3
3. NodeJS 8 LTS and NPM 5.6
4. Angular CLI 6.0.5
5. Electron 2.0.2
6. Yarn 1.7.0
7. Go 1.10.2
8. PostgreSQL 10.4
9. .NET Core 2.1.200
10. PHP 7.2.5
11. Composer 1.6.5
12. Python 3.6.5
13. Java OpenJDK 8
14. Jenkins 2.107.3
15. Perl 5.22.1
16. Nginx 1.13.12
17. SDKMAN! 5.6.4
18. Maven 3.5.3
19. Gradle 4.7
20. Kotlin 1.2.41
21. Grails 3.3.5
22. Scala 2.12.6
23. Spring CLI 2.0.2

## Commands

### 1. Command to build the Docker image
```
sudo docker build -t dockdev:1.0 .
```
### 2. Command to run the Docker image
```
sudo docker run -it dockdev:1.0
```
## Additional Information

### PostgreSQL credential information:
```
Username: postgres

Password: 123
```

### Exposed Port:
None. No port is exposed.
You need to identify the IP address of the Docker container running based on this Docker image first, and then connect to that IP address and the ports that you are using.

## Warning

Since this Dockerfile contains many software development packages, there are a few things that we must be aware before using this Dockerfile:
1. The internet bandwidth consumption needed to pull the packages will be quite a lot. Don't use any quota-based internet connection.
2. The resulting image size of this Dockerfile will be quite a lot.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
