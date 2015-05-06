package com.Leo.utils {
	
	public function msgbox(prMsg:String):String {
		var str:String = "";
		switch (prMsg) {
			case "cigi":
				str = 'There are more complex rules for importing tobacco products. Please refer to the <u><a href="http://www.customs.govt.nz/features/charges/feetypes/Pages/default.aspx">Customs website</a></u> for more information.';
				break;
			case "alcohol":
				str = 'There are more complex rules for importing alcohol products as it depends on the amount of alcohol in the product you are importing. Please refer to the <u><a href="http://www.customs.govt.nz/features/charges/feetypes/Pages/default.aspx">Customs website</a></u> for more information.';
				break;
			case "firearms":
				str = 'You must have a permit from the NZ Police to import firearms. For more information refer to the <u><a href="http://www.police.govt.nz/service/firearms/importing.html">NZ Police</a></u> website.';
				break;
			case '-50':
				str = 'You don\'t have to pay any duty or GST as it totals less than $60. Please be aware that this is an estimate only and the amount shown may change when a proper assessment is made once your goods arrive in New Zealand.';
				break;
			case '50-60':
				str = 'You are close to the $60 threshold, so you may have to pay duty and GST if it totals over $60. Please be aware that this is an estimate only and the amount shown may change when a proper assessment is made once your goods arrive in New Zealand.';
				break;
			case '60+':
				str = 'You will have to pay duty and GST as it\'s above the $60 threshold. Please be aware that this is an estimate only and the amount shown may change when an assessment is made once your goods arrive in New Zealand.';
		}
		return str;
	}
	
}