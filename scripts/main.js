// Variable Declarations

const currentDate = new Date()
const referenceDate = new Date()

// [[ Function Declarations ]] 

function currentColor() {
	const current = currentDate.getTime()
	const reference = referenceDate.getTime()
	
	const differenceMilliseconds = (current - reference) / 1000
	const differenceSeconds = Math.floor(differenceMilliseconds)
	
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
