<?php
session_start();
{
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        if (isset($_POST['otp'])) {
            $otp = $_POST['otp'];
            if ($otp == $_SESSION['otp']) {
                // OTP is correct
                echo json_encode(['status' => true]);
            } else {
                // OTP is incorrect
                echo json_encode(['status' => false]);
            }
        } else {
            echo json_encode(['status' => false, 'message' => 'OTP not provided']);
        }
    } else {
        echo json_encode(['status' => false, 'message' => 'Invalid request method']);
    }
    }
    ?>
