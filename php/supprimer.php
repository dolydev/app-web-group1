<?php
require_once 'connect.php';

if($_GET['id']){
    $id = $_GET['id'];

    $req = $db->prepare("DELETE FROM stagiaires WHERE id = ?");
    $req->execute(array($id));
    header("Location:liste-stagiaires.php");
}else{
    $erreur = "Aucun Identifiant";
}

?>