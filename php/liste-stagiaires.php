<?php
require_once 'connect.php';

if(isset($_POST['envoyer'])){
    if(!empty($_POST['nom']) AND !empty($_POST['prenom']) AND !empty($_POST['formation'])){
        $nom = htmlspecialchars($_POST['nom']);
        $prenom = htmlspecialchars($_POST['prenom']);
        $formation = htmlspecialchars($_POST['formation']);

        $req = $db->prepare("INSERT INTO stagiaires (nom,prenom,formation) VALUES(?,?,?)");
        $req->execute(array($nom,$prenom,$formation));
        $erreur = "Insertion  effectué";

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
                    <h4 class="alert alert-danger text-center">Enregistrement Des Stagiaires</h4>
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

                <div class="col-sm-7 mt-5">
                    <h4 class="alert alert-info text-center"> Liste des stagiaires</h4>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th scope="col">Id</th>
                                <th scope="col">Nom</th>
                                <th scope="col">Prenom</th>
                                <th scope="col">Formation</th>
                                <th scope="col">Action</th>
                            </tr>
                        </thead>
                        <?php
                        $list = $db->prepare("SELECT * FROM stagiaires");
                        $list->execute();
                        while($af=$list->fetch())
                        {
                            ?>
                            <tr>
                                <th scope="row"><?=$af['id']?></th>
                                <td><?=$af['nom']?></td>
                                <td><?=$af['prenom']?></td>
                                <td><?=$af['formation']?></td>
                                <td>
                                    <a href="modifier.php?id=<?=$af['id']?>" class="btn btn-success">Modifier</a>
                                    <a href="supprimer.php?id=<?=$af['id']?>" class="btn btn-dark">Supprimer</a>
                                </td>
                                

                            </tr>
                            <?php 
                        }
                        ?>
                    </table>
                </div>


            </div>
        </div>

    </body>
</html>
<script src="js/bootstrap.bundle.js"></script>
