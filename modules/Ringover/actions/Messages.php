<?php
require_once 'vendor/autoload.php';
use Symfony\Component\Yaml\Yaml;

class Ringover_Messages_Action extends Vtiger_BasicAjax_Action
{

    public function process(Vtiger_Request $request)
    {
        $id=$request->get('id');
        $curl = curl_init();
        curl_setopt_array($curl, array(
            CURLOPT_URL => "https://public-api.ringover.com/v2/conversations/$id/messages",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "GET",
            CURLOPT_HTTPHEADER => array(
                "Content-Type: application/x-www-form-urlencoded",
                "Content-Length: 0",
                "Authorization : 2ff3b9bc4f0fa238ed52c7d8569f2711bde9b40c" 
            )
        ));
        $retour = curl_exec($curl);
        $array = Yaml::parse($retour, Yaml::PARSE_OBJECT_FOR_MAP);
        echo json_encode($array);
    }
}
