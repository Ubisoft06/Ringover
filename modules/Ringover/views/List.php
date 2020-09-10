<?php
class Ringover_List_View extends Vtiger_Index_View
{

        public function process(Vtiger_Request $request)
        {
                $viewer = $this->getViewer($request);
                $moduleName = $request->getModule();
                $viewer->view('List.tpl', $moduleName);
        }
}
