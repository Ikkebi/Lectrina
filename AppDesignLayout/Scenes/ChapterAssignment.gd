extends Control

var assignment : Dictionary;

func start_assignment(assignment):
	self.assignment = assignment

	$Question.text = assignment["question"]
	
	$Answer1.text = assignment["answer1"]
	$Answer2.text = assignment["answer2"]
	$Answer3.text = assignment["answer3"]
	$Answer4.text = assignment["answer4"]
	
	self.show()

func on_answer_pressed(answer_idx):
	var correct = answer_idx == assignment["correct_answer"]
	
	if not correct:
		# show error to user
		return
	
	get_parent().finish_chapter()
