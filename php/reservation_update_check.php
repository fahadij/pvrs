<?php

// Connect to the database
$servername = "127.0.0.1";
$username = "root";
$password = "root";
$dbname = "pvers";

try {
  $db = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
} catch(PDOException $e) {
  echo
 
"Connection failed: " . $e->getMessage();
  exit;
}

// Get current time
$current_time = date('Y-m-d H:i:s');

// Open a log file for writing
$logFile = fopen("reservation_update_log.txt", "a");

// Fetch all reservations
$sql = "SELECT * FROM reservation";
$stmt = $db->prepare($sql);
$stmt->execute();

$reservations = $stmt->fetchAll(PDO::FETCH_ASSOC);

foreach ($reservations as $reservation) {

  // Write reservation details to the log file
  fwrite($logFile, "\n\nProcessing reservation: " . $reservation['RESno']);
  fwrite($logFile, "\nCurrent status: " . $reservation['RES_Status']);
  fwrite($logFile, "\nStart time: " . $reservation['RES_DateTime_start']);
  fwrite($logFile, "\nEnd time: " . $reservation['RES_DateTime_end']);

  // Skip expired reservations
  if ($reservation['RES_Status'] == 'expired') {
    fwrite($logFile, "\nSkipping reservation - already expired.");
    continue;
  }

  // Check if pending reservation needs activation
  if ($reservation['RES_Status'] == 'pending' && $current_time >= $reservation['RES_DateTime_start']) {
    // Update status to active

    $sql = "UPDATE reservation SET RES_Status = 'active' WHERE RESno = :RESno";
    try {
      $stmt = $db->prepare($sql);

      // Bind parameters
      $stmt->bindParam(':RESno', $reservation['RESno']);

      // Execute and handle potential errors
      if ($stmt->execute()) {
        $affectedRows = $stmt->rowCount();
        fwrite($logFile, "\nUpdated status to active. Affected rows: $affectedRows.");
      } else {
        // Get error information
        $errorInfo = $stmt->errorInfo();

        // Log error details
        fwrite($logFile, "\nError updating status: " . $errorInfo[2]);
      }
    } catch (PDOException $e) {
      fwrite($logFile, "\nError: " . $e->getMessage());
    }
  }

  // Check if active reservation needs expiration
  if ($reservation['RES_Status'] == 'active' && $current_time >= $reservation['RES_DateTime_end']) {
    // Update status to expired

    $sql = "UPDATE reservation SET RES_Status = 'expired' WHERE RESno = :RESno";
    try {
      $stmt = $db->prepare($sql);

      // Bind parameters
      $stmt->bindParam(':RESno', $reservation['RESno']);

      // Execute and handle potential errors
      if ($stmt->execute()) {
        $affectedRows = $stmt->rowCount();
        fwrite($logFile, "\nUpdated status to expired. Affected rows: $affectedRows.");
      } else {
        // Get error information
        $errorInfo = $stmt->errorInfo();

        // Log error details
        fwrite($logFile, "\nError updating status: " . $errorInfo[2]);
      }
    } catch (PDOException $e) {
      fwrite($logFile, "\nError: " . $e->getMessage());
    }
  }
}

// Close the log file
fclose($logFile);

// Sleep for 60 seconds
sleep(60);

?>