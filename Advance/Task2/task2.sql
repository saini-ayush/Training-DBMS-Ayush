CREATE TABLE PROJECT (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    `key` VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_project_key (`key`)
);

CREATE TABLE USER (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
);

CREATE TABLE PROJECT_MEMBER (
    project_member_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT NOT NULL,
    user_id INT NOT NULL,
    role VARCHAR(50) NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES PROJECT(project_id),
    FOREIGN KEY (user_id) REFERENCES USER(user_id),
    UNIQUE KEY unique_project_user (project_id, user_id)
);

CREATE TABLE ISSUE_TYPE (
    issue_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(255),
    INDEX idx_name (name)
);

CREATE TABLE STATUS (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    order_index INT NOT NULL,
    UNIQUE KEY unique_order_index (order_index)
);

CREATE TABLE PRIORITY (
    priority_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    order_index INT NOT NULL,
    UNIQUE KEY unique_order_index (order_index)
);

CREATE TABLE SPRINT (
    sprint_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    start_date TIMESTAMP NULL,
    end_date TIMESTAMP NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES PROJECT(project_id),
    INDEX idx_project_dates (project_id, start_date, end_date)
);

CREATE TABLE ISSUE (
    issue_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    reporter_id INT NOT NULL,
    assignee_id INT,
    issue_type_id INT NOT NULL,
    status_id INT NOT NULL,
    priority_id INT NOT NULL,
    sprint_id INT,
    due_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES PROJECT(project_id),
    FOREIGN KEY (reporter_id) REFERENCES USER(user_id),
    FOREIGN KEY (assignee_id) REFERENCES USER(user_id),
    FOREIGN KEY (issue_type_id) REFERENCES ISSUE_TYPE(issue_type_id),
    FOREIGN KEY (status_id) REFERENCES STATUS(status_id),
    FOREIGN KEY (priority_id) REFERENCES PRIORITY(priority_id),
    FOREIGN KEY (sprint_id) REFERENCES SPRINT(sprint_id),
    INDEX idx_project_status (project_id, status_id),
    INDEX idx_assignee (assignee_id),
    INDEX idx_sprint (sprint_id)
);

CREATE TABLE COMMENT (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    issue_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES ISSUE(issue_id),
    FOREIGN KEY (user_id) REFERENCES USER(user_id),
    INDEX idx_issue_date (issue_id, created_at)
);

CREATE TABLE ATTACHMENT (
    attachment_id INT PRIMARY KEY AUTO_INCREMENT,
    issue_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    fileUrl VARCHAR(2048) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES ISSUE(issue_id),
    INDEX idx_issue_id (issue_id)
);