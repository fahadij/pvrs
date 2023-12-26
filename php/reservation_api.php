<?php

// Connect to the database
$servername = "127.0.0.1";
$username = "root";
$password = "root";
$dbname = "pvers";

try {
  $db = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
  $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
  echo json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $e->getMessage()]);
  exit;
}

// Start the session
session_start();

// Get the vehicle ID from the request
$vehicle_id = $_GET['vehicle_id'];

// Check if the vehicle is available
$sql = "SELECT * FROM vehicle WHERE V_num = :vehicle_id AND V_status = '0'";
$stmt = $db->prepare($sql);
$stmt->bindParam(':vehicle_id', $vehicle_id);
$stmt->execute();

$vehicle = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$vehicle) {
  echo json_encode(['status' => 'error', 'message' => 'Vehicle not available']);
  exit;
}

// Check if the vehicle is already reserved
$start_date = $_GET['start_time'];
$end_date = $_GET['end_time'];

// Build the SQL query to check for conflicts
$sql = "SELECT * FROM reservation WHERE V_num_RES = :vehicle_id AND ((:start_date BETWEEN RES_DateTime_start AND RES_DateTime_end) OR (:end_date BETWEEN RES_DateTime_start AND RES_DateTime_end) OR (RES_DateTime_start BETWEEN :start_date AND :end_date))";

$stmt = $db->prepare($sql);

// Bind parameters
$stmt->bindParam(':vehicle_id', $vehicle_id);
$stmt->bindParam(':start_date', $start_date);
$stmt->bindParam(':end_date', $end_date);

// Execute the query
$stmt->execute();

// Check if any conflicts exist
$reservations = $stmt->fetchAll(PDO::FETCH_ASSOC);

if (count($reservations) > 0) {
  // Vehicle is unavailable for the selected dates
  echo json_encode(['status' => 'error', 'message' => 'Vehicle already reserved during this time']);
  exit;
}

// Check if any conflicting reservations exist
if (count($reservations) > 0) {
  // Vehicle is unavailable for the selected dates
  echo json_encode(['status' => 'error', 'message' => 'Vehicle already reserved during this time']);
}

$reservation = $stmt->fetch(PDO::FETCH_ASSOC);

if ($reservation) {
  echo json_encode(['status' => 'error', 'message' => 'Vehicle already reserved']);
  exit;
}

// Reserve the vehicle
$reservation_start_time = date('Y-m-d H:i:s');
$reservation_duration = 60 * 60; // Set the reservation duration to 1 hour (60 minutes)
$reservation_end_time = date('Y-m-d H:i:s', strtotime($reservation_start_time) + $reservation_duration);

$sql = "INSERT INTO reservation (vehicle_id, user_id, reservation_start_time, reservation_end_time) VALUES (:vehicle_id, :user_id, :reservation_start_time, :reservation_end_time)";
$stmt = $db->prepare($sql);
$stmt->bindParam(':vehicle_id', $vehicle_id);
$stmt->bindParam(':user_id', $_SESSION['user_id']);
$stmt->bindParam(':reservation_start_time', $reservation_start_time);
$stmt->bindParam(':reservation_end_time', $reservation_end_time);

if ($stmt->execute()) {
  header('Content-Type: application/json');
  echo json_encode(['status' => 'success', 'message' => 'Vehicle reserved successfully']);
} else {
  echo json_encode(['status' => 'error', 'message' => 'An error occurred while reserving the vehicle']);
}

?>