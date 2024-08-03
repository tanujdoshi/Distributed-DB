
CREATE TABLE Hotel
(
    Hotel_id       INT NOT NULL,
    Name           VARCHAR(255),
    Address        VARCHAR(255),
    Contact_number VARCHAR(255),
    Licence_number VARCHAR(255),
    Email          VARCHAR(255),
    PRIMARY KEY (Hotel_id)
);

CREATE TABLE Customer
(
    Customer_id              INT NOT NULL,
    Customer_name            VARCHAR(255),
    Customer_contact_number  VARCHAR(255),
    Customer_id_proof        VARCHAR(255),
    Customer_id_proof_number VARCHAR(255),
    Customer_email           VARCHAR(255),
    Customer_address         VARCHAR(255),
    Customer_date_of_birth   DATETIME,
    PRIMARY KEY (Customer_id)
);

CREATE TABLE Room_type
(
    Room_type_id  INT NOT NULL,
    Room_capacity INT,
    Room_price    INT,
    PRIMARY KEY (Room_type_id)
);


CREATE TABLE Room
(
    Room_id       INT NOT NULL,
    Hotel_id      INT,
    Room_number   INT,
    Room_type_id  INT,
    Room_floor_no INT,
    PRIMARY KEY (Room_id),
    FOREIGN KEY (Hotel_id) REFERENCES Hotel (Hotel_id),
    FOREIGN KEY (Room_type_id) REFERENCES Room_type (Room_type_id)
);


CREATE TABLE Staff
(
    Employee_number      INT NOT NULL,
    Password             VARCHAR(255),
    Staff_name           VARCHAR(255),
    Staff_contact_number VARCHAR(255),
    Staff_post           VARCHAR(255),
    Employment_type      VARCHAR(255),
    Staff_address        VARCHAR(255),
    Staff_salary         INT,
    PRIMARY KEY (Employee_number)
);

CREATE TABLE Transportation
(
    Transportation_id   INT,
    Transportation_type VARCHAR(255),
    Driver_name         VARCHAR(255),
    Number_of_guests    INT,
    Pickup_location     VARCHAR(255),
    Car_number_plate    VARCHAR(255),
    PRIMARY KEY (Transportation_id)
);

CREATE TABLE Room_reservation
(
    Room_reservation_id INT NOT NULL,
    Customer_id         INT,
    Room_id             INT,
    Payment_id          INT,
    Transportation_id   INT,
    Check_in_date       DATETIME,
    Check_out_date      DATETIME,
    No_of_guests        INT,
    Advance_payment     DECIMAL(30, 2),
    Final_bill_amount   DECIMAL(30, 2),
    PRIMARY KEY (Room_reservation_id),
    FOREIGN KEY (Customer_id) REFERENCES Customer (Customer_id),
    FOREIGN KEY (Room_id) REFERENCES Room (Room_id),
    FOREIGN KEY (Transportation_id) REFERENCES Transportation (Transportation_id)
);

CREATE TABLE Shop
(
    Shop_id             INT NOT NULL,
    Hotel_id            INT,
    Shop_location       VARCHAR(255),
    Shop_owner_name     VARCHAR(255),
    Shop_contact_number VARCHAR(15),
    PRIMARY KEY (Shop_id),
    FOREIGN KEY (Hotel_id) REFERENCES Hotel (Hotel_id)
);


CREATE TABLE Maintenance
(
    Maintenance_id INT NOT NULL,
    Hotel_id       INT,
    Cost           DECIMAL(10, 2),
    Issue_detail   TEXT,
    PRIMARY KEY (Maintenance_id),
    FOREIGN KEY (hotel_id) REFERENCES Hotel (hotel_id)
);

CREATE TABLE `Order`
(
    Order_id            INT NOT NULL,
    Room_reservation_id INT,
    Order_time          DATETIME,
    Amount              DECIMAL(30, 2),
    PRIMARY KEY (Order_id),
    FOREIGN KEY (Room_reservation_id) REFERENCES Room_reservation (Room_reservation_id)
);

CREATE TABLE Amenity
(
    Amenity_id       INT NOT NULL,
    Amenity_type     VARCHAR(255),
    Opening_hours    DATETIME,
    Capacity         INT,
    Amenity_location VARCHAR(255),
    PRIMARY KEY (Amenity_id)
);

CREATE TABLE Bill
(
    Bill_id      INT NOT NULL,
    Room_id      INT,
    Customer_id  INT,
    Payment_date DATETIME,
    Payment_type VARCHAR(255),
    Amount       DECIMAL(30, 2),
    PRIMARY KEY (Bill_id),
    FOREIGN KEY (Customer_id) REFERENCES Customer (Customer_id),
    CONSTRAINT p_type CHECK (Payment_type IN ("card", "cash"))
);


CREATE TABLE Transaction
(
    Transaction_id   INT NOT NULL,
    Bill_id          INT,
    Transaction_type VARCHAR(255),
    Amount           DECIMAL(30, 2),
    Date             DATETIME,
    PRIMARY KEY (Transaction_id),
    FOREIGN KEY (Bill_id) REFERENCES Bill (Bill_id),
    CONSTRAINT t_type CHECK (Transaction_type IN ("credit", "debit"))
);


CREATE TABLE Inventory
(
    Inventory_Id   INT            NOT NULL,
    Name           VARCHAR(255)   NOT NULL,
    Stock          INT            NOT NULL,
    Price_per_unit DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (Inventory_Id)
);

CREATE TABLE Menu
(
    Menu_id     INT          NOT NULL,
    Name        VARCHAR(255) NOT NULL,
    Description TEXT,
    PRIMARY KEY (Menu_id)
);


CREATE TABLE Menu_Item
(
    Menu_item_id INT            NOT NULL,
    Menu_id      INT            NOT NULL,
    Name         VARCHAR(255)   NOT NULL,
    Price        DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (Menu_item_id),
    FOREIGN KEY (Menu_id) REFERENCES Menu (Menu_id)
);


CREATE TABLE Restaurant
(
    Restaurant_id INT          NOT NULL,
    Hotel_id      INT          NOT NULL,
    Name          VARCHAR(255) NOT NULL,
    Description   TEXT,
    Location      VARCHAR(255) NOT NULL,
    Menu_id       INT,
    PRIMARY KEY (Restaurant_id),
    FOREIGN KEY (Menu_id) REFERENCES Menu (Menu_id),
    FOREIGN KEY (Hotel_id) REFERENCES Hotel (Hotel_id)
);


CREATE TABLE Membership_Type
(
    Membership_type_id INT            NOT NULL,
    Name               VARCHAR(255)   NOT NULL,
    Description        TEXT,
    Validity           INT            NOT NULL,
    Hotel_id           INT            NOT NULL,
    Price              DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (Membership_type_id),
    FOREIGN KEY (Hotel_id) REFERENCES Hotel (Hotel_id)
);


CREATE TABLE Membership
(
    Membership_Id      INT  NOT NULL,
    Membership_type_id INT  NOT NULL,
    Customer_id        INT  NOT NULL,
    Joining_date       DATE NOT NULL,
    Exit_date          DATE,
    PRIMARY KEY (Membership_id),
    FOREIGN KEY (Membership_type_id) REFERENCES Membership_type (Membership_type_Id),
    FOREIGN KEY (Customer_id) REFERENCES Customer (Customer_id)
);



CREATE TABLE Order_item_quantity
(
    Order_quantity_id INT NOT NULL,
    Menu_item_id      INT,
    Quantity          INT NOT NULL,
    Amount            DECIMAL(30, 2),
    FOREIGN KEY (Menu_item_id) REFERENCES Menu_item (Menu_item_Id),
    PRIMARY KEY (Order_quantity_id)
);

CREATE TABLE Order_Item
(
    Order_item_Id       INT NOT NULL,
    Room_reservation_id INT,
    Order_id            INT NOT NULL,
    Order_quantity_id   INT NOT NULL,
    FOREIGN KEY (Order_quantity_id) REFERENCES Order_item_quantity (Order_quantity_id),
    PRIMARY KEY (Order_item_id)
);

CREATE TABLE Parking
(
    Parking_id           INT,
    Parking_slot_number  INT,
    Parking_floor_number INT,
    Availability         INT,
    Price                DECIMAL(30, 2),
    PRIMARY KEY (Parking_id)
);

CREATE TABLE Feedback
(
    Feedback_id   INT,
    Customer_id   INT,
    Feedback_date DATETIME,
    Description   LONGTEXT,
    PRIMARY KEY (Feedback_id),
    FOREIGN KEY (Customer_id) REFERENCES Customer (Customer_id)
);

CREATE TABLE hotel_owners
(
    Hotel_owner_id             INT AUTO_INCREMENT,
    Hotel_id                   INT,
    Hotel_owner_name           VARCHAR(255),
    Hotel_owner_contact_number VARCHAR(12),
    Partnership_percentage     INT,
    PRIMARY KEY (Hotel_owner_id),
    FOREIGN KEY (Hotel_id) REFERENCES Hotel (Hotel_id)
);

CREATE TABLE hotel_events
(
    Hotel_events_id   INT,
    Hotel_id          INT,
    Event_name        VARCHAR(255),
    Event_description LONGTEXT,
    Event_time        DATETIME,
    Entry_charge      INT,
    Capacity          INT,
    PRIMARY KEY (Hotel_events_id),
    FOREIGN KEY (Hotel_id) REFERENCES Hotel (Hotel_id)
);

CREATE TABLE Activity_Center
(
    Activity_center_id INT,
    Hotel_id           INT,
    Name               VARCHAR(255),
    Description        TEXT,
    Opening_hours      VARCHAR(255),
    Activities_offered TEXT,
    Contact_number     VARCHAR(50),
    PRIMARY KEY (Activity_center_id)
);

CREATE TABLE Housekeeping
(
    Housekeeping_id INT,
    Staff_id        INT,
    Room_id         INT,
    Date            DATE,
    Tasks           TEXT,
    Status          ENUM ('completed', 'pending'),
    PRIMARY KEY (Housekeeping_id)
);


CREATE TABLE Guest_Preferences
(
    Preference_id       INT,
    Customer_id         INT,
    Room_preference     VARCHAR(255),
    Food_allergies      TEXT,
    Bed_type_preference VARCHAR(50),
    Additional_notes    TEXT,
    PRIMARY KEY (Preference_id)
);

CREATE TABLE Cleaning_Schedule
(
    Schedule_id       INT,
    Room_id           INT,
    Date              DATE,
    Time_slot         VARCHAR(50),
    Staff_id_assigned INT,
    Status            ENUM ('scheduled', 'completed', 'canceled'),
    PRIMARY KEY (Schedule_id)
);

CREATE TABLE Guest_Complaints
(
    Complaint_id      INT,
    Customer_id       INT,
    Date              DATE,
    Description       TEXT,
    Resolution_status VARCHAR(255),
    Staff_id_assigned INT,
    PRIMARY KEY (Complaint_id)
);

CREATE TABLE Staff_Training
(
    Training_id           INT,
    Name                  VARCHAR(255),
    Description           TEXT,
    Required_for_position VARCHAR(255),
    Frequency             VARCHAR(255),
    Last_conducted_date   DATE,
    Next_scheduled_date   DATE,
    PRIMARY KEY (Training_id)
);

CREATE TABLE Lost_and_found
(
    Item_id              INT,
    Description          TEXT,
    Found_location       VARCHAR(255),
    Date_found           DATE,
    Status               ENUM ('claimed', 'unclaimed'),
    Claimant_customer_id INT,
    Date_claimed         DATE,
    PRIMARY KEY (Item_id)
);


CREATE TABLE Entertainment_Offerings
(
    Offering_id INT,
    Hotel_id    INT,
    Name        VARCHAR(255),
    Type        VARCHAR(255),
    Schedule    TEXT,
    Location    VARCHAR(255),
    Price       DECIMAL(10, 2),
    PRIMARY KEY (Offering_id)
);


