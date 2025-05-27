# Lost and Found Management System

## Table of Contents
- [Project Description](#project-description)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Key Functionalities Powered by SQL](#key-functionalities-powered-by-SQL)
  <!-- - [Usage](#usage) --> <!-- - [Database Schema](#database-schema) - [Project Timeline](#project-timeline) -->
<!-- - [Acknowledgments](#acknowledgments) -->

## Project Description

The Lost and Found Management System streamlines the process of reporting and tracking lost items, logging found items, and notifying users when there is a potential match between lost and found items based on shared attributes like description and location. The goal of the system is to enhance the efficiency of the traditional Lost and Found process by reducing the time it takes to reunite items with their rightful owners.

## Features

- **User Management**: Users can register as either students or staff members.
- **Item Reporting**: Users can report lost or found items with detailed descriptions, including categories, location, and date.
- **Item Tracking**: Search for items using dynamic filters and track the status of the reported items.
- **Notifications**: Users receive notifications when there is a potential match for their lost or found items.
- **Claims**: Users can claim items, and the system automatically updates the status to "Claimed"
- **Analytics and Insights**: Database operations like aggregation, grouping, and queries, provide insights like lost items counts by category or top categories per building.

## Technology Stack

- **Backend**: SQL, Express.js, Node.js - for robust server-side logic and database interactions.
- **Frontend**: HTML - for building a user-friendly and responsive website.
- **Database**: Oracle Relational Database Management System (RDBMS) - ensuring secure and efficient data handling.
- **Version Control**: Git - for collaborative code management and tracking changes.

## Key Functionalities Powered by SQL
- **Aggregation and Analytics**: Query insights into lost item counts by category, or top categories per building, using ***GROUP BY and nested queries***.
- **Dynamic Search and Updates**: Implement dynamic filters to search items or update item attributes.
- **User Reporting Insights**: Identify users who report items across all categories using ***DIVISION operators***.

This project highlights the practical application of relational database design, complex SQL queries, and integrated backend logic in a full-stack environment.

<!-- 
By including our names and student numbers, we certify that the work in this project was performed solely by us.

## Acknowledgments

- University of British Columbia, Vancouver
- Department of Computer Science

Special thanks to our course instructors and TAs for their guidance.

Please note that all code, scripts, and resources used in this project comply with the University's academic integrity policies. We have not used any unauthorized aids and have cited all external resources appropriately. -->

