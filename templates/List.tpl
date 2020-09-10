{*+**********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.1
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 ************************************************************************************}
{strip}
    <!-- CSS only -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css">
    <style type='text/css'>
        .label{
            border-radius : 10px!important;
            font-size : 12px ! important;
        }
        body {
            font-size : 14px!important;
        }
    </style>
    <div class="container">
        <ul class="nav nav-pills nav-justified" style="padding-top : 15px; position : fixed; width:90%;z-index : 1034; background:#fff !important">
            <li role="presentation" class="active"><a href="#">Equipe</a></li>
            <li role="presentation"><a href="#">Contacts</a></li>
            <li role="presentation"><a href="#">Appels</a></li>
            <li role="presentation"><a href="#">Messages</a></li>
        </ul>
        <div id="contenu">
        </div>
    </div>
    <script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/plug-ins/1.10.21/sorting/date-euro.js"></script>
    <script type="text/javascript">
        $(document).ready(function(){
            team();
        });
        function datatables(){
            $(".table").dataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/French.json"
                }
            });
        }
        function team(){
            let text = "<div class='table-responsive' style='margin-top : 6rem'>"+
                    "<h2 class='text-center' id='titre'>Liste des équipes</h2>"+
                    "<table class='table'>"+
                        "<thead>"+
                            "<th>Nom</th>"+
                            "<th>Prenom</th>"+
                            "<th>Companie</th>"+
                            "<th>Email</th>"+
                            "<th>Picture</th>"+
                        "</thead>"+
                        "<tbody></tbody>"+
                    "</table>"+
                "</div>";
            $.ajax({
                url : 'index.php',
                type : 'GET',
                data : {
                    module : 'Ringover',
                    action : 'Team'
                },
                dataType : 'json',
                success : function(data){
                    $(text).appendTo("#contenu");
                    data.list.forEach(element => {
                        $(".table > tbody").append("<tr><td>"+element.firstname+"</td><td>"+element.lastname+"</td><td>"+element.company+"</td><td>"+element.email+"</td><td><img class='img-circle' src='"+element.picture+"' style='width :50px'></td></tr>");
                    });
                    datatables();
                }
            })
        }

        function contact(){
            let text = "<div class='table-responsive' style='margin-top : 6rem'>"+
                    "<h2 class='text-center' id='titre'>Liste des contacts</h2>"+
                    "<table class='table'>"+
                        "<thead>"+
                            "<th>Nom</th>"+
                            "<th>Companie</th>"+
                            "<th>Type</th>"+
                            "<th>International</th>"+
                        "</thead>"+
                        "<tbody></tbody>"+
                    "</table>"+
                "</div>";
                $.ajax({
                    url :'index.php',
                    type :'GET',
                    data : {
                        module : 'Ringover',
                        action : 'Contacts'
                    },
                    dataType : 'json',
                    success : function(data){
                        $(text).appendTo("#contenu");
                        data.contact_list.forEach(element => {
                            var tr = "<tr>"+
                            "<td>"+element.concat_name+"</td>"+
                            "<td>"+element.company+"</td>"+
                            "<td>"+element.numbers[0].type+"</td>"+
                            "<td>"+element.numbers[0].format.international+"</td>"+
                            "</tr>";
                            $(".table > tbody").append(tr);
                            console.log(element.numbers);
                        });
                        datatables();
                    }

                   
                })
        }

        function appels(){
            let text = "<div class='table-responsive' style='margin-top : 6rem'>"+
                    "<h2 class='text-center' id='titre'>Liste des appels</h2>"+
                    "<table class='table'>"+
                        "<thead>"+
                            "<th>Debut</th>"+
                            "<th>Fin</th>"+
                            "<th>Type</th>"+
                            "<th>Nom</th>"+
                            "<th>Numero</th>"+
                            "<th>Direction</th>"+
                            "<th>Status</th>"+
                        "</thead>"+
                        "<tbody></tbody>"+
                    "</table>"+
                "</div>";
            $.ajax({
                url : 'index.php',
                type : 'GET',
                data : {
                    module : 'Ringover',
                    action : 'Calls'
                },
                dataType : 'json',
                success : function(data){
                    $(text).appendTo("#contenu");
                    data.call_list.forEach(element => {
                        var username = "";
                        if(element.user){
                            username = element.user.firstname+" "+element.user.lastname;
                        }else{
                            username = "Anonyme";
                        }
                        var state = "";
                        if(element.last_state == "MISSED"){
                            state = "<span class='label label-warning'>Manqué</span>";
                        }else if(element.last_state == "ANSWERED"){
                            state = "<span class='label label-success'>Répondu</span>"
                        }else if(element.last_state == "QUEUE_TIMEOUT"){
                            state = "<span class='label label-default'>Appel d'attente</span>"
                        }else if(element.last_state == "VOICEMAIL"){
                            state = "<span class='label label-info'>Messagerie Vocale</span>"
                        }else{
                            state = "<span class='label label-danger'>Pas de réponse</span>"
                        }
                        var direction = "";
                        if(element.direction == "out"){
                            direction = "<i class='fa fa-arrow-circle-up fa-2x' style='color : #5bb85b;'></i>"
                        }else{
                            direction = "<i class='fa fa-arrow-circle-down fa-2x' style='color :#777777'></i>"
                        }
                        var tr = "<tr>"+
                        "<td>"+new Date(element.start_time).toLocaleDateString()+" "+new Date(element.start_time).toLocaleTimeString()+"</td>"+
                        "<td>"+new Date(element.end_time).toLocaleDateString()+" "+new Date(element.end_time).toLocaleTimeString()+"</td>"+
                        "<td>"+element.type+"</td>"+
                        "<td>"+username+"</td>"+
                        "<td style='text-align: right'>"+element.contact_number+"</td>"+
                        "<td style='text-align: center'>"+direction+"</td>"+
                        "<td style='text-align: center'>"+state+"</td>"+
                        "</tr>";
                        $(".table > tbody").append(tr);
                    });
                    $(".table").dataTable({
                        "language": {
                            "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/French.json"
                        },
                        "columnDefs": [
                            { type: 'date-euro', targets: 0 },
                            { type: 'date-euro', targets: 1 }
                        ],
                        "order": [
                            [ 0, "desc" ]
                        ]
                    });
                }
            })
        }

        function messages(){
            let text = "<div class='table-responsive' style='margin-top : 6rem'>"+
                    "<h2 class='text-center' id='titre'>Liste des conversations</h2>"+
                    "<table class='table'>"+
                        "<thead>"+
                            "<th>Debut</th>"+
                            "<th>Fin</th>"+
                            "<th>Type</th>"+
                            "<th>Nom ou Numero</th>"+
                            "<th>Dernière message</th>"+
                            "<th>Direction</th>"+
                            "<th>Action</th>"+
                        "</thead>"+
                        "<tbody></tbody>"+
                    "</table>"+
                "</div>";
            $.ajax({
                url : 'index.php',
                type : "GET",
                data : {
                    module : 'Ringover',
                    action : 'Conversations'
                },
                dataType : 'json',
                success : function(data){
                    $(text).appendTo("#contenu");
                    data.conversation_list.forEach(element => {
                        var username = "";
                        if(element.type == "INTERNAL"){
                            if(element.internal.length > 1){
                                username = element.internal[1].user.concat_name;
                            }else{
                                username = element.internal[0].user.concat_name;
                            }
                        }else{
                            if(element.external.length > 1){
                                username = element.external[1].number.international;
                            }else {
                                if(element.external[0].number){
                                    username = element.external[0].number.international;
                                }else{
                                    username = element.external[0].alphanumeric;
                                }
                            }
                        }
                        var msg;
                        var direction = "";
                        if(element.last_message){
                            if(element.last_message.direction == "IN"){
                                direction = "<i class='fa fa-inbox fa-2x'></i>";
                            }else{
                                direction = "<i class='fa fa-send fa-2x'></i>";
                            }
                            msg = element.last_message.buffer;
                        }else{
                            direction = "";
                            msg = "";
                        }
                        var tr = "<tr>"+
                        "<td>"+new Date(element.creation_date).toLocaleDateString()+" "+new Date(element.creation_date).toLocaleTimeString()+"</td>"+
                        "<td>"+new Date(element.update_date).toLocaleDateString()+" "+new Date(element.update_date).toLocaleTimeString()+"</td>"+
                        "<td>"+element.type+"</td>"+
                        "<td>"+username+"</td>"+
                        "<td style='text-align : justify; width:40%'>"+msg+"</td>"+
                        "<td>"+direction+"</td>"+
                        "<td><a onclick=\"detail('"+element.conversation_id+"')\" class='label label-primary' style='cursor : pointer'>Voir detail</td>"+
                        "</tr>";
                        $(".table > tbody").append(tr);
                    });
                    $(".table").dataTable({
                        "language": {
                            "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/French.json"
                        },
                        "columnDefs": [
                            { type: 'date-euro', targets: 0 },
                            { type: 'date-euro', targets: 1 }
                        ],
                        "order": [
                            [ 0, "desc" ]
                        ]
                    });
                }
            });
        }

        function liste_noire(){
            let text = "";
            $.ajax({
                
            })
        }
        $(".nav-pills > li > a").on('click', function(){
            var a = $(this);
            $('.nav-pills > li').removeClass('active');
            a.parents('li').addClass('active');
            $("#contenu").empty();
            if(a.text()=='Equipe'){
                team();
            }else if(a.text() == 'Appels'){
                appels();
            }else if(a.text() == 'Contacts'){
                contact();
            }else if(a.text() == 'Messages'){
                messages();
            }
        });
        function detail(id_conversation){
             let text = "<div class='table-responsive' style='margin-top : 6rem'>"+
                    "<h2 class='text-center' id='titre'>Detail de la conversation</h2>"+
                    "<table class='table'>"+
                        "<thead>"+
                            "<th>Date du message</th>"+
                            "<th>Nom ou Numéro</th>"+
                            "<th>Direction</th>"+
                            "<th>Message</th>"+
                        "</thead>"+
                        "<tbody></tbody>"+
                    "</table>"+
                "</div>";
            if(id_conversation){
                $("#contenu").empty();
                $("#contenu").append(text);
                $.ajax({
                    url : 'index.php',
                    type : 'GET',
                    data : {
                        module : 'Ringover',
                        action : 'Messages',
                        id : id_conversation
                    },
                    dataType : 'json',
                    success : function(data){
                        if(data.message_list){
                            data.message_list.forEach(element => {
                                var msg = "";
                                var direction ="";
                                if(element.direction == "IN"){
                                    direction = "<i class='fa fa-inbox fa-2x'></i>";
                                }else{
                                    direction = "<i class='fa fa-send fa-2x'></i>";
                                }
                                msg = element.buffer;
                                var username = "";
                                if(element.user){
                                    username = element.user.concat_name;
                                }else if(element.number){
                                    username = element.number.international
                                }
                                var tr = "<tr>"+
                                    "<td>"+new Date(element.creation_date).toLocaleDateString()+" "+new Date(element.creation_date).toLocaleTimeString()+"</td>"+
                                    "<td>"+username+"</td>"+
                                    "<td>"+direction+"</td>"+
                                    "<td style='text-align : justify; width:40%'>"+msg+"</td>"+
                                "</tr>";
                                $(".table > tbody").append(tr);
                            });
                        }
                    }
                })
            }
        }
    </script>
{/strip}
