const fs = require('fs');

var kicksMapping = {
    7: 'Front Low Kick',
    8: 'Rear Low Kick',
    9: 'Front Mid Kick',
    10: 'Rear Mid Kick',
    11: 'Front High Kick',
    12: 'Rear High Kick',
    13: 'Front Knee',
    14: 'Rear Knee'
}


var currentCombo = "";
var comboLengthMin = 6; //minimum combo length
var comboLengthMax = 6; //maximum combo length
var isKickBox = true; //set to true to activate kickboxing
var allowBodyStrikes = true; //set to true to allow body strikes
var isBodyChance =  20; //increase number to decrease body strikes
var allCombos = [];
var noOfIters = 50000;

for (let c = 1; c <= noOfIters; c++) {
    let currentKicks = 0;
    let skipKicks = false;
    let maxKicksInCombo = 1; //how many kicks should be in the combo
    var currentStrikes = [];
    while (currentCombo.split(',').length < comboLengthMax) {
        let currentNumber = isKickBox ? Math.round(Math.random() * (15 - 1) + 1) : Math.round(Math.random() * (7 - 1) + 1);
        let isBody = Math.round(Math.random() * (isBodyChance - 1) + 1) == isBodyChance;
        let lastStrikeInComboAsNum;
        if (currentCombo == "" &&
            currentNumber <= 7) {
            if(currentNumber == 7){
                currentNumber = 1;
            }
            isBody && allowBodyStrikes && currentNumber != 5 && currentNumber != 6 ? currentCombo += 'b' + currentNumber.toString() : currentCombo += currentNumber.toString();
            currentStrikes.push(currentNumber);
        } else if (currentCombo == "" &&
            currentNumber >= 7) {
                if(currentNumber == 15){
                    currentNumber = 1;
                }
            currentCombo += kicksMapping[currentNumber];
            currentKicks += 1;
            currentStrikes.push(currentNumber);
        }
        let lastNumberIndex = currentStrikes.length - 1;
        lastStrikeInComboAsNum = parseInt(currentStrikes[lastNumberIndex]);
      //  isNaN(lastStrikeInComboAsNum) ? lastStrikeInComboAsNum = currentNumber : lastStrikeInComboAsNum = parseInt(currentStrikes[lastNumberIndex]);
        var lastStrikeEvenOrOdd = lastStrikeInComboAsNum % 2;
        //lastNumberIndex = currentStrikes.length - 1;
        let lastStrikeInCombo = currentCombo[currentCombo.length - 1];
        // let lastStrikeInComboAsNum = parseInt(currentStrikes[lastNumberIndex]);
        if (currentNumber == 1) {
            if (lastStrikeInComboAsNum == 1) {
                var chance = Math.round(Math.random() * (3 - 1) + 1);
                if (chance == 1) {
                    isBody && allowBodyStrikes ? currentCombo += ', b1' :
                        currentCombo += ', 1';
                    currentStrikes.push(currentNumber);
                }
            }
        }
        if (currentNumber == 2) {
            if (lastStrikeEvenOrOdd != 0) {
                isBody && allowBodyStrikes ? currentCombo += ', b2' :
                    currentCombo += ', 2';
                currentStrikes.push(currentNumber);
            }
        }
        if (currentNumber == 3) {
            if (lastStrikeEvenOrOdd == 0) {
                isBody && allowBodyStrikes ? currentCombo += ', b3' :
                    currentCombo += ', 3';
                currentStrikes.push(currentNumber);
            } else if (
                lastStrikeInComboAsNum == 3
            ) {
                var chance = Math.round(Math.random() * (3 - 1) + 1);
                if (chance == 1) {
                    isBody && allowBodyStrikes ? currentCombo += ', b3' :
                        currentCombo += ', 3';
                    currentStrikes.push(currentNumber);
                }
            } else if (
                lastStrikeInComboAsNum == 1
            ) {
                var chance = Math.round(Math.random() * (3 - 1) + 1);
                if (chance == 1) {
                    isBody && allowBodyStrikes ? currentCombo += ', b3' :
                        currentCombo += ', 3';
                    currentStrikes.push(currentNumber);
                }
            }
        }
        if (currentNumber == 4) {
            if (lastStrikeEvenOrOdd != 0) {
                isBody && allowBodyStrikes ? currentCombo += ', b4' :
                    currentCombo += ', 4';
                currentStrikes.push(currentNumber);
            }
        }
        if (currentNumber == 5) {
            if (lastStrikeEvenOrOdd == 0 && lastStrikeInComboAsNum != 6) {
                isBody && allowBodyStrikes ? currentCombo += ', b3' :
                    currentCombo += ', 5';
                currentStrikes.push(currentNumber);

            }
        }
        if (currentNumber == 6) {
            if (lastStrikeEvenOrOdd != 0 && lastStrikeInComboAsNum != 5) {
                isBody && allowBodyStrikes ? currentCombo += ', b4' :
                    currentCombo += ', 6';
                currentStrikes.push(currentNumber);
            }
        }
        if (isKickBox) { //lastStrikeInCombo !== 'k' && lastStrikeInCombo !== 'e' means it's not kick or knee. Takes last letter.
            if (currentNumber == 7) {
                if (lastStrikeEvenOrOdd == 0 && !([7, 8, 9, 10, 11, 12, 13, 14].includes(lastStrikeInComboAsNum)) && !skipKicks) {
                    currentCombo += ', Front Low Kick';
                    currentKicks += 1
                    currentStrikes.push(currentNumber);

                }
            }
            if (currentNumber == 8 && !([7, 8, 9, 10, 11, 12, 13, 14].includes(lastStrikeInComboAsNum)) && !skipKicks) {
                if (lastStrikeEvenOrOdd != 0) {
                    currentCombo += ', Rear Low Kick';
                    currentKicks += 1
                    currentStrikes.push(currentNumber);

                }
            }
            if (currentNumber == 9 && !([7, 8, 9, 10, 11, 12, 13, 14].includes(lastStrikeInComboAsNum)) && !skipKicks) {
                if (lastStrikeEvenOrOdd == 0) {
                    currentCombo += ', Front Mid Kick';
                    currentKicks += 1
                    currentStrikes.push(currentNumber);

                }
            }
            if (currentNumber == 10 && !([7, 8, 9, 10, 11, 12, 13, 14].includes(lastStrikeInComboAsNum)) && !skipKicks) {
                if (lastStrikeEvenOrOdd != 0) {
                    currentCombo += ', Rear Mid Kick';
                    currentKicks += 1
                    currentStrikes.push(currentNumber);

                }
            }
            if (currentNumber == 11 && !([5, 6, 7, 8, 9, 10, 11, 12, 13, 14].includes(lastStrikeInComboAsNum)) && !skipKicks) {
                if (lastStrikeEvenOrOdd == 0) {
                    currentCombo += ', Front High Kick';
                    currentKicks += 1
                    currentStrikes.push(currentNumber);

                }
            }
            if (currentNumber == 12 && !([5, 6, 7, 8, 9, 10, 11, 12, 13, 14].includes(lastStrikeInComboAsNum)) && !skipKicks) {
                if (lastStrikeEvenOrOdd != 0) {
                    currentCombo += ', Rear High Kick';
                    currentKicks += 1
                    currentStrikes.push(currentNumber);

                }
            }
            if (currentNumber == 13 && !([7, 8, 9, 10, 11, 12, 13, 14].includes(lastStrikeInComboAsNum)) && !skipKicks) {
                if (lastStrikeEvenOrOdd == 0) {
                    currentCombo += ', Front Knee';
                    currentKicks += 1
                    currentStrikes.push(currentNumber);

                }
            }
            if (currentNumber == 14 && !([7, 8, 9, 10, 11, 12, 13, 14].includes(lastStrikeInComboAsNum)) && !skipKicks) {
                if (lastStrikeEvenOrOdd != 0) {
                    currentCombo += ', Rear Knee';
                    currentKicks += 1
                    currentStrikes.push(currentNumber);

                }
            }
            if (currentKicks == maxKicksInCombo) {
                skipKicks = true;
            }
            if(currentCombo.includes('undefined')){
                var asd = 1;
            }
        }
    }


    let totalStrikesInCombo = currentCombo.split(',');
    currentCombo += "|\n";
    if (allCombos.indexOf(currentCombo) == -1 && !currentCombo.includes('undefined')) {
        allCombos.push(currentCombo)
        if (totalStrikesInCombo.length <= comboLengthMax && totalStrikesInCombo.length >= comboLengthMin) {
            console.log("combo added: " + currentCombo);
            fs.appendFile('C:/Users/alest/test.txt', currentCombo, err => {
                if (err) {
                    console.error(err);
                }
            });
        }
    }
    // console.log("iter number " + c + " out of " + noOfIters);
    currentCombo = "";
}