// Variable Declarations

const currentDate = new Date()
const referenceDate = new Date()

// [[ Function Declarations ]] 

function currentColor() {
	const current = currentDate.getTime() / 1000
	const reference = referenceDate.getTime() / 1000
	
	const difference = current - reference
	
	alert(difference)
}

// [[ Init ]]

{
	// Setup Date
	
	referenceDate.setHours(0)
	referenceDate.setMinutes(0)
	referenceDate.setSeconds(0)
	referenceDate.setMilliseconds(0)
}

{
	// Setup Clock
	
	setInterval(currentColor, 1000)
}
