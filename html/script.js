document.addEventListener('DOMContentLoaded', () => {
  let gameArea;
  let balanceValueDisplay;
  let startingBalanceDisplay;
  let currentCashValue;
  let initialCashValue;
  let cashMultiplier;
  let mines;
  let bombClicked = false;
  let countdownInterval;
  let safeClickCount = 0;

  window.addEventListener('message', function(event) {
    var data = event.data;

    if (data.action === 'open') {
        const gameContainer = document.getElementById('game-container');
        gameContainer.style.display = '';
        gameContainer.style.opacity = 0;

        setTimeout(() => {
            gameContainer.style.opacity = 1;
        }, 50);

        initGame(data.title, data.iconClass, data.gridSize, data.startingBalance, data.multiplier, data.specialItem, data.timeoutDuration);
    }

    if (data.action === 'fadeOut') {
        fadeOutAndReset();
    }
});

function initGame(title = 'Register Balance', iconClass = 'fas fa-shopping-cart', gridSize = 5, startingBalance = Math.floor(Math.random() * 1000), multiplier = 1.2, specialItem = '', timeoutDuration = null) {
    if (countdownInterval) {
        clearInterval(countdownInterval);
    }

    gameArea = document.querySelector('.grid');
    balanceValueDisplay = document.getElementById('current-balance');
    startingBalanceDisplay = document.getElementById('starting-balance');
    currentCashValue = initialCashValue = startingBalance;
    cashMultiplier = multiplier;
    specialItemGlobal = specialItem;

    document.querySelector('.balance-title').innerText = title;

    const countdownElement = document.getElementById('countdown');
    if (timeoutDuration !== null && timeoutDuration !== undefined) {
        startCountdown(timeoutDuration);
        countdownElement.style.display = 'block';
    } else {
        countdownElement.style.display = 'none';
    }

    balanceValueDisplay.style.color = '';

    const cashoutButton = document.getElementById('cashout');
    cashoutButton.style.backgroundColor = '';
    cashoutButton.style.cursor = '';
    cashoutButton.disabled = false;

    gridSize = Math.max(3, Math.min(gridSize, 8));
    createGrid(gridSize, gridSize, iconClass); 
    updateCashDisplay();
}

function updateCashDisplay() {
  if (!balanceValueDisplay || !startingBalanceDisplay) {
      return;
  }

  balanceValueDisplay.innerText = `$${currentCashValue}`;
  startingBalanceDisplay.innerText = `START BALANCE: $${initialCashValue} (${cashMultiplier.toFixed(2)}x)`;
}

  function resetGame() {
    currentCashValue = initialCashValue = 0;
    cashMultiplier = 1.12;
    safeClickCount = 0;
  
    updateCashDisplay();
  }

  function startCountdown(duration) {
    if (!duration && duration !== 0) {
        const countdownElement = document.getElementById('countdown');
        countdownElement.style.display = 'none';
        return;
    }

    let timer = duration, minutes, seconds;
    const countdownElement = document.getElementById('countdown');
    countdownElement.style.display = 'block';

    countdownInterval = setInterval(function () {
        minutes = parseInt(timer / 60000, 10);
        seconds = parseInt((timer % 60000) / 1000, 10);

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        countdownElement.textContent = minutes + ":" + seconds;

        if ((timer -= 1000) < 0) {
            clearInterval(countdownInterval);
            countdownElement.style.display = 'none';
            gameOver();
        }
    }, 1000);
}

  function fadeOutAndReset() {
    const gameContainer = document.getElementById('game-container');
    gameContainer.style.transition = 'opacity 0.5s ease';
    gameContainer.style.opacity = '0';
    bombClicked = false; 
  
    setTimeout(() => {
      gameContainer.style.display = 'none';
      resetGame();
    }, 1500);
  }

  function createGrid(rowCount, colCount, iconClass) {
    gameArea.innerHTML = '';
    gameArea.style.gridTemplateColumns = `repeat(${colCount}, 60px)`;

    mines = new Set();
    while (mines.size < rowCount) {
        mines.add(Math.floor(Math.random() * rowCount * colCount));
    }

    const goldenIndex = Math.floor(Math.random() * rowCount * colCount);
    mines.delete(goldenIndex);

    for (let i = 0; i < rowCount * colCount; i++) {
        const cell = document.createElement('div');
        cell.classList.add('cell');
        cell.innerHTML = `<i class="${iconClass}"></i>`;
        cell.dataset.index = i;
        cell.addEventListener('click', cellClick);
        gameArea.appendChild(cell);

        if (i === goldenIndex) {
            cell.classList.add('golden');
        }
    }
}

  function cellClick() {
    if (this.classList.contains('revealed')) {
        return;
    }

    this.innerHTML = '';
    const index = parseInt(this.dataset.index);

    if (this.classList.contains('golden')) {
        this.innerHTML = '<i class="fas fa-crown"></i>';
        this.classList.add('revealed', 'golden-revealed');

        if (specialItemGlobal === '' || specialItemGlobal === null) {
            currentCashValue = Math.floor(initialCashValue * 1.5);
        }

        updateCashDisplay();
        this.style.cursor = 'not-allowed';
    } else if (mines.has(index)) {
        bombClicked = true;
        this.innerHTML = '<i class="fas fa-bomb"></i>';
        this.classList.add('revealed', 'mine');
        gameOver();
    } else {
        this.innerHTML = '<i class="fas fa-check"></i>';
        this.classList.add('revealed', 'safe');

        const fixedIncreaseAmount = Math.floor(initialCashValue * (cashMultiplier - 1));
        
        currentCashValue += fixedIncreaseAmount;
        updateCashDisplay();
        this.style.cursor = 'not-allowed';
    }
}

  function gameOver() {
    const goldenRevealed = document.querySelector('.golden-revealed') != null;
    clearInterval(countdownInterval);
    const countdownElement = document.getElementById('countdown');
    countdownElement.style.display = 'none';
    countdownElement.textContent = "00:00";

    document.querySelectorAll('.cell').forEach(cell => {
      const index = parseInt(cell.dataset.index);

      if (mines.has(index)) {
        cell.innerHTML = '<i class="fas fa-bomb"></i>';
        cell.classList.add('revealed', 'mine');
      } else if (cell.classList.contains('golden')) {
        cell.innerHTML = '<i class="fas fa-crown"></i>';
        cell.classList.add('revealed', 'golden');
      }

      if (!cell.classList.contains('revealed')) {
        cell.style.transition = 'background-color 0.5s ease';
        cell.style.backgroundColor = '#5B5A5A';
        cell.innerHTML = '';
      }

      cell.removeEventListener('click', cellClick);
    });

    if (bombClicked) {
      balanceValueDisplay.style.color = 'red';
      currentCashValue = initialCashValue;
    }

    const cashoutButton = document.getElementById('cashout');
    cashoutButton.style.backgroundColor = '#5B5A5A';
    cashoutButton.style.cursor = 'not-allowed';
    cashoutButton.disabled = true;
    safeClickCount = 0;

    fetch('https://sd-minesweeper/gameOver', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({ 
        cashAmount: currentCashValue,
        goldenBox: goldenRevealed,
        specialItem: specialItemGlobal
      })
    }).then(() => {
      fadeOutAndReset();
    });
  }

  document.getElementById('cashout').addEventListener('click', function() {
    gameOver();
    balanceValueDisplay.style.color = 'green';
  });

  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      gameOver();
    }
  });
  resetGame();
});