<?php
require_once 'connect.php';

if(isset($_POST['envoyer'])){
    if(!empty($_POST['nom']) AND !empty($_POST['prenom']) AND !empty($_POST['formation']))
    {
        $nom = htmlspecialchars($_POST['nom']);
        $prenom = htmlspecialchars($_POST['prenom']);
        $formation = htmlspecialchars($_POST['formation']);

        $req = $db->prepare("UPDATE stagiaires SET nom=?,prenom=?,formation=? WHERE id=?");
        $req->execute(array($nom,$prenom,$formation,$_GET['id']));
        $erreur = "Modification  effectué";
        header("Location:liste-stagiaires.php");

    }else{
        $erreur = "Vous devez remplir tous les champs";
    }
}
?>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gestion des stagiaires Devops</title>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/all.min.css">
    </head>
    <body>
        <div class="container">
            <h4 class="alert alert-danger text-center">Gestion D'etablissement Greta Saint Germain En Laye</h4>
            <div class="row">
                <div class="col-sm-5 mt-5">
                    <h4 class="alert alert-danger text-center">Modification Des Stagiaires</h4>
                    <form action="" method="POST">
                        <div>
                            <input type="text" class="form-controle mt-1" name="nom" placeholder="Nom de l'élève">
                        </div>
                        <div>
                            <input type="text" class="form-controle mt-1" name="prenom" placeholder="Prenom de l'élève">
                        </div>
                        <div>
                            <input type="text" class="form-controle mt-1" name="formation" placeholder="formation de l'élève">
                        </div>
                        <div>
                            <input type="submit" name="envoyer" class="btn btn-success mt-1">
                            <?php
                                if(isset($erreur)){
                                ?><h6 class="alert alert-warning mt-1">
                                    <?php echo $erreur;
                                }
                                ?>
                                </h6>
                        </div>
                    </form>
                </div>
    
            </div>
        </div>

    </body>
</html>
<script src="js/bootstrap.bundle.js"></script>