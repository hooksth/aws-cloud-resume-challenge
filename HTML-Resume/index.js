const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch("https://krwo73mzyjw5dn6xrlhht3qfxm0isekf.lambda-url.us-east-1.on.aws/")
    let data = await response.json()
    counter.innerHTML = ` Viewer Count: ${data}`;
}

updateCounter();