/*
// Connect to the database
$db = new PDO('mysql:host=localhost;dbname=your_database_name', 'your_username', 'your_password');

// Start the session
session_start();

// Check if the user is logged in
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

// Get the vehicle ID from the request
$vehicle_id = $_GET['vehicle_id'];

// Check if the vehicle is available
$sql = "SELECT * FROM vehicles WHERE id = :vehicle_id AND status = 'available'";
$stmt = $db->prepare($sql);
$stmt->bindParam(':vehicle_id', $vehicle_id);
$stmt->execute();

$vehicle = $stmt->fetch();

if (!$vehicle) {
    echo 'Vehicle not available';
    exit;
}

// Check if the vehicle is already reserved
$sql = "SELECT * FROM reservations WHERE vehicle_id = :vehicle_id AND current_timestamp() BETWEEN reservation_start_time AND reservation_end_time";
$stmt = $db->prepare($sql);
$stmt->bindParam(':vehicle_id', $vehicle_id);
$stmt->execute();

$reservation = $stmt->fetch();

if ($reservation) {
    echo 'Vehicle already reserved';
    exit;
}

// Reserve the vehicle
$reservation_start_time = date('Y-m-d H:i:s');
$reservation_duration = 60 * 60; // Set the reservation duration to 1 hour (60 minutes)
$reservation_end_time = date('Y-m-d H:i:s', strtotime($reservation_start_time) + $reservation_duration);

$sql = "INSERT INTO reservations (vehicle_id, user_id, reservation_start_time, reservation_end_time) VALUES (:vehicle_id, :user_id, :reservation_start_time, :reservation_end_time)";
$stmt = $db->prepare($sql);
$stmt->bindParam(':vehicle_id', $vehicle_id);
$stmt->bindParam(':user_id', $_SESSION['user_id']);
$stmt->bindParam(':reservation_start_time', $reservation_start_time);
$stmt->bindParam(':reservation_end_time', $reservation_end_time);
$stmt->execute();

echo 'Vehicle reserved successfully';
*/



<?php

// Connect to the database
$db = new PDO('mysql:host=localhost;dbname=your_database_name', 'your_username', 'your_password');

// Start the session
session_start();

// Check if the user is logged in
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

// Get the vehicle ID from the request
$vehicle_id = $_GET['vehicle_id'];

// Check if the vehicle is available
$sql = "SELECT * FROM vehicles WHERE id = :vehicle_id AND status = 'available'";
$stmt = $db->prepare($sql);
$stmt->bindParam(':vehicle_id', $vehicle_id);
$stmt->execute();

$vehicle = $stmt->fetch();

if (!$vehicle) {
    echo 'Vehicle not available';
    exit;
}

// Check if the vehicle is already reserved
$sql = "SELECT * FROM reservations WHERE vehicle_id = :vehicle_id AND current_timestamp() BETWEEN reservation_start_time AND reservation_end_time";
$stmt = $db->prepare($sql);
$stmt->bindParam(':vehicle_id', $vehicle_id);
$stmt->execute();

$reservation = $stmt->fetch();

if ($reservation) {
    echo 'Vehicle already reserved';
    exit;
}

// Reserve the vehicle
$reservation_start_time = date('Y-m-d H:i:s');
$reservation_duration = 60 * 60; // Set the reservation duration to 1 hour (60 minutes)
$reservation_end_time = date('Y-m-d H:i:s', strtotime($reservation_start_time) + $reservation_duration);

$sql = "INSERT INTO reservations (vehicle_id, user_id, reservation_start_time, reservation_end_time) VALUES (:vehicle_id, :user_id, :reservation_start_time, :reservation_end_time)";
$stmt = $db->prepare($sql);
$stmt->bindParam(':vehicle_id', $vehicle_id);
$stmt->bindParam(':user_id', $_SESSION['user_id']);
$stmt->bindParam(':reservation_start_time', $reservation_start_time);
$stmt->bindParam(':reservation_end_time', $reservation_end_time);
$stmt->execute();

echo 'Vehicle reserved successfully';

?>