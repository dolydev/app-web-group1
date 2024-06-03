CREATE TABLE IF NOT EXISTS stagiaires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    formation VARCHAR(255) NOT NULL
);
INSERT INTO stagiaires (nom, prenom, email, date_naissance) VALUES
('Doe', 'John', 'john.doe@example.com', '1990-01-01'),
('Smith', 'Jane', 'jane.smith@example.com', '1992-02-02');
