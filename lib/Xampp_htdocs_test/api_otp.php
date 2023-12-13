<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;
session_start();
require 'C:\Users\hellking101\vendor\autoload.php';

$mail = new PHPMailer(true);
if(!empty($_POST['email_owner'])){
$mail3 = $_POST['email_owner'];

}else if(!empty($_POST['email_renter'])){
    $mail3 = $_POST['email_renter'];

}else{ $mail3 = "";
    echo json_encode(["error" => "Message could not be sent. error on email:$mail3"]);}
    
    var_dump($_POST['owner']);
    var_dump($_POST['renter']);
    var_dump($_POST['id']);
    $otp = rand(100000, 999999);
    $_SESSION['otp'] = $otp;

    $mail->SMTPDebug = SMTP::DEBUG_SERVER;
    $mail->isSMTP();
    $mail->Host       = "smtp.gmail.com";
    $mail->SMTPAuth   = true;
    $mail->Username   = 'k71196782@gmail.com';
    $mail->Password   = 'lpht dgmp jqch nzde';
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
    $mail->Port       = 587;

    $mail->setFrom('k71196782@gmail.com', 'PVRE');
    $mail->addAddress($mail3);

    $mail->isHTML(true);
    $mail->Subject = 'Here is your PVRS otp';
    $mail->Body    = 'The code is: ' . $otp;

    if ($mail->send()) {
        echo json_encode(["message" => "OTP Sent", "status" => "Success"]);
    } else {
        echo json_encode(["error" => "Message could not be sent. Mailer Error: {$mail->ErrorInfo}"]);
    }

    $servername = "127.0.0.1";
$username = "root";
$password = "root";
$dbname = "pvers";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
if(!empty($_POST['email_owner'])){
    $sqlQuery =  "UPDATE owner SET otp = '$otp' WHERE owner_id = {$_POST['id']}";
    $conn->query($sqlQuery);
}elseif(!empty($_POST['email_renter'])){
    $sqlQuery1 =  "UPDATE renter SET otp = '$otp' WHERE Renter_ID = {$_POST['id']}";
    $conn->query($sqlQuery1);
}



?>
