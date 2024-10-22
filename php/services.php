<section>
    <h2>O que podemos fazer pelo seu negócio?</h2>
    <div class="serviços">
        <?php
        $servicos = [
            ["img" => "icon1.png", "titulo" => "Desenvolvimento de Sites", "descricao" => "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eveniet ipsam sunt aspernatur id? Minus
                        reprehenderit repellendus nisi quidem consectetur quisquam. Nam, placeat illo? Dignissimos
                        corrupti
                        cupiditate laudantium distinctio error nostrum!"],
            ["img" => "icon2.png", "titulo" => "Desenvolvimento de Apps", "descricao" => "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eveniet ipsam sunt aspernatur id? Minus
                        reprehenderit repellendus nisi quidem consectetur quisquam. Nam, placeat illo? Dignissimos
                        corrupti
                        cupiditate laudantium distinctio error nostrum!"],
            ["img" => "icon3.png", "titulo" => "Consultoria em Saúde Digital", "descricao" => "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eveniet ipsam sunt aspernatur id? Minus
                        reprehenderit repellendus nisi quidem consectetur quisquam. Nam, placeat illo? Dignissimos
                        corrupti
                        cupiditate laudantium distinctio error nostrum!"]
        ];

        foreach ($servicos as $servico) {
            echo '
            <div class="card">
                <img src="' . $servico["img"] . '">
                <div class="card-text">
                    <h3>' . $servico["titulo"] . '</h3>
                    <p>' . $servico["descricao"] . '</p>
                </div>
                <div class="text-ocult">
                    <h3>Outro Conteúdo</h3>
                    <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eveniet ipsam sunt aspernatur id? Minus
                        reprehenderit repellendus nisi quidem consectetur quisquam. Nam, placeat illo? Dignissimos
                        corrupti
                        cupiditate laudantium distinctio error nostrum!</p>
                </div>
            </div>';
        }
        ?>
    </div>
</section>
