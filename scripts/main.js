// [[ Variable Declarations ]]

let body = document.body
let bodyStyle = body.style

let clockText = document.getElementById("clock")

// [[ Function Declarations ]] 

function currentColor() {
	const currentDate = new Date()
	const referenceDate = new Date()

	referenceDate.setHours(0)
	referenceDate.setMinutes(0)
	referenceDate.setSeconds(0)
    
	const current = currentDate.getTime()
	const reference = referenceDate.getTime()
	
	const differenceMilliseconds = current - reference
	const differenceSeconds = Math.floor(differenceMilliseconds / 1000)
	
	const color = differenceSeconds.toString(16)
    
	bodyStyle.backgroundColor = color

	clockText.innerHTML = "0x" + color
	document.title = "0x" + color
}

// [[ Init ]]

{
	// Setup Clock
    
	currentColor()
	setInterval(currentColor, 1000)
}
