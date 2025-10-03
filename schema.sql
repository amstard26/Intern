-- Quick DB setup for internship finder. Run this in MySQL to create tables and sample data.
-- Sample user: email 'student@example.com', pw 'password123' (hashed already)

CREATE DATABASE IF NOT EXISTS internship_finder;
USE internship_finder;

-- Users—store emails, hashed pws, skills, location
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    saved_skills TEXT,  -- Comma-separated like "Python,React"
    preferred_location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Internships—job listings with skills needed
CREATE TABLE internships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    company VARCHAR(255) NOT NULL,
    location VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    required_skills TEXT NOT NULL,  -- Comma-separated
    status ENUM('active', 'inactive') DEFAULT 'active',
    posted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_company (company),
    INDEX idx_location (location),
    INDEX idx_status (status)
);

-- Saved stuff—track what users like
CREATE TABLE saved_internships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    internship_id INT NOT NULL,
    saved_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (internship_id) REFERENCES internships(id) ON DELETE CASCADE,
    UNIQUE KEY unique_save (user_id, internship_id),
    INDEX idx_user_id (user_id),
    INDEX idx_internship_id (internship_id)
);

-- Sample users—pw is 'password123' hashed with bcrypt
INSERT INTO users (email, password_hash, saved_skills, preferred_location) VALUES
('student@example.com', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'Python,React,JavaScript,SQL', 'San Francisco, CA'),
('john@example.com', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'Java,Spring Boot,AWS,Docker', 'New York, NY');

-- Sample internships—mix of tech roles
INSERT INTO internships (title, company, location, description, required_skills) VALUES
('Frontend Developer Intern', 'TechCorp Inc.', 'San Francisco, CA', 'Join our dynamic frontend team to build cutting-edge web applications using React and modern JavaScript frameworks.', 'React,JavaScript,HTML,CSS,TypeScript'),
('Backend Developer Intern', 'DataSystems LLC', 'New York, NY', 'Work on scalable backend systems and learn about microservices architecture and cloud technologies.', 'Python,Java,SQL,AWS,Docker'),
('Full Stack Developer Intern', 'StartupXYZ', 'San Francisco, CA', 'Perfect opportunity for full stack developers to work on both frontend and backend projects in a fast-paced startup environment.', 'JavaScript,React,Node.js,Python,PostgreSQL'),
('Data Science Intern', 'AnalyticsPro', 'Austin, TX', 'Analyze large datasets and build machine learning models to solve real-world business problems.', 'Python,R,SQL,Machine Learning,Statistics'),
('DevOps Engineer Intern', 'CloudTech Solutions', 'Seattle, WA', 'Learn about cloud infrastructure, CI/CD pipelines, and automation tools in a production environment.', 'AWS,Docker,Kubernetes,Python,Bash'),
('Mobile Developer Intern', 'AppWorks Studio', 'Boston, MA', 'Develop cross-platform mobile applications using React Native and work on both iOS and Android platforms.', 'React Native,JavaScript,TypeScript,iOS,Android'),
('UX/UI Design Intern', 'DesignHub', 'Los Angeles, CA', 'Create beautiful and intuitive user interfaces while learning about user research and design systems.', 'Figma,Sketch,Adobe XD,UI Design,UX Research');
