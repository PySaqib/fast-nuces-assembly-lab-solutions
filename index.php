<!DOCTYPE html>
<html lang="en">
<head>

    <!--SEO META TAGS-->
    <!-- Primary Meta Tags -->
    <title>FAST-NUCES Assembly Solutions Directory for COAL Course.</title>
    <meta name="title" content="FAST-NUCES Assembly Solutions Directory for COAL Course.">
    <meta name="description" content="Get the best assembly language solutions for FAST-NUCES's infamous Computer Architecture and Assembly Language (COAL) course. Learn and succeed!">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://metatags.io/">
    <meta property="og:title" content="FAST-NUCES Assembly Solutions Directory for COAL Course.">
    <meta property="og:description" content="Get the best assembly language solutions for FAST-NUCES's infamous Computer Architecture and Assembly Language (COAL) course. Learn and succeed!">
    <meta property="og:image" content="https://metatags.io/assets/meta-tags-16a33a6a8531e519cc0936fbba0ad904e52d35f34a46c97a2c9f6f7dd7d336f2.png">

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image">
    <meta property="twitter:url" content="https://metatags.io/">
    <meta property="twitter:title" content="FAST-NUCES Assembly Solutions Directory for COAL Course.">
    <meta property="twitter:description" content="Get the best assembly language solutions for FAST-NUCES's infamous Computer Architecture and Assembly Language (COAL) course. Learn and succeed!">
    <meta property="twitter:image" content="https://metatags.io/assets/meta-tags-16a33a6a8531e519cc0936fbba0ad904e52d35f34a46c97a2c9f6f7dd7d336f2.png">

    
    <!--Google Fonts-->
    <!--

        I know it's a bad idea to import these first but if the website ain't sexy, it ain't worth it.

    -->

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@200;700&display=swap" rel="stylesheet">

    <!--Optimized for phones-->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    
    <!-- 
    Boostrap
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous"> -->

    <!--Custom Stylesheet-->
    <link rel="stylesheet" href="web_app/css/index-css.css" />

    <!--Icons Font. This allows for all of the icons that you see on the website.-->
    <script src="https://kit.fontawesome.com/164e7b143f.js" crossorigin="anonymous"></script>

</head>
<body>
    

    <div class="container">


        <div class="row">

            <div class="col">

                <p id="title">Assembly Solutions Directory for FAST-NUCES</p>

            </div>

        </div>

        <div class="row">

            <p id="subTitle">Find solutions to


            <mark>
            over
            <?php

                // Counting the number of solutions currently in the catalog.

                $files = new FilesystemIterator('lab_solutions/', FilesystemIterator::SKIP_DOTS);

                echo iterator_count($files);

                if (iterator_count($files) > 1) {
                    echo ' problems.';
                }
                else {
                    echo ' problem.';
                }


            ?>

            </mark>

            </p> 

        </div>


        <form action="" method="post">


            <div class="row" id="searchBox">

                <div class="col" id="searchInput">
                
                    <input type="text" name="query" id="query" placeholder="program to print hello world"
                    
                    <?php


                        if (isset($_POST['query'])) {
                            echo 'value="'. 
                            htmlspecialchars($_POST['query'], ENT_QUOTES) . '"';
                        }

                    ?>

                    />

                </div>

                <div class="col" id="searchBtn">

                    <button id="search">
                        <i class="fas fa-search"></i>
                    </button>

                </div>

            </div>

            <?php


                // Search handling logic.

                if (isset($_POST['query'])) {

                    $termFound = false;
                    
                    if ($termFound) {


                        


                    }
                    else {


                    echo    '<div class="row" id="searchResult">
                        
                                <div class="col">
                                        
                                    <p id="result">No search results found.</p>
                
                                </div>
        
                            </div>';


                    }


                }


            ?>


        </form>


    </div>

</body>
</html>