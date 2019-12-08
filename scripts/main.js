// Variable Declarations

const date = new Date()

// [[ Function Declarations ]] 

function currentColor() {
	const current = date.getTime()
	
	alert(current)
}

setInterval(currentColor, 1000)
