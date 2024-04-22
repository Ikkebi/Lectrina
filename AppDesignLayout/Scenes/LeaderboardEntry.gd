extends HBoxContainer

func set_entry(position, username, xp):
	$Position.text = str(position) + "."
	$Username.text = username
	$Exp.text = str(xp) + " exp"
