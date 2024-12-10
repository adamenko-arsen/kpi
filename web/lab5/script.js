/* Helper extensions */

function cookie_get(key)
{
    const cookies = document.cookie.split("; ");

    for (let cookie of cookies)
    {
        const [it_key, value] = cookie.split("=");

        if (key == it_key)
        {
            return value;
        }
    }
    return null;
}

function cookie_set(key, value)
{
    const date = new Date();
    date.setTime(date.getTime() + 60 * 1000);
    const expires = "expires=" + date.toUTCString();

    document.cookie = `${key}=${value}; ${expires}; path=/`;
}

function cookie_remove(key)
{
    document.cookie = `${key}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/`;
}

function store_get(key)
{
    return localStorage.getItem(key);
}

function store_set(key, value)
{
    localStorage.setItem(key, value);
}

function store_remove(key)
{
    localStorage.removeItem(key);
}

function strictParseFloat(input)
{
    const floatRegex = /^[+-]?[0-9]+(\.[0-9]*)?$/;

    if (floatRegex.test(input))
    {
        return parseFloat(input);
    }
    else
    {
        return null;
    }
}

/* Task 1 */

function task_1()
{
    let header = document.getElementById('header-x');
    let footer = document.getElementById('footer-y');

    let header_x = header.getHTML();
    let footer_y = footer.getHTML();

    header.setHTMLUnsafe(footer_y);
    footer.setHTMLUnsafe(header_x);
}

/* Task 2 */

function task_2()
{
    let inputRadius = document.getElementById('task-2-input').value;
    let output = document.getElementById('task-2-output');

    if (inputRadius == '')
    {
        output.textContent = 'The input is empty';
        return;
    }

    let mayParsedRadius = strictParseFloat(inputRadius);

    if (mayParsedRadius == null)
    {
        output.textContent = 'The input has to be a number (radius)!';
        return;
    }

    let radius = mayParsedRadius;

    let square = Math.PI * Math.pow(radius, 2);

    output.textContent = `Square: ${square.toString()}`;
}

/* Task 3 */

const TASK_3_COOKIE_NAME = 'task_3';

function task_3_input()
{
    let strNumbers = document.getElementById('task-3-input').value.split(' ');
    let status = document.getElementById('task-3-output-status');

    let numbers = [];

    for (let strNumber of strNumbers)
    {
        let mayNumber = strictParseFloat(strNumber);

        if (mayNumber == null)
        {
            status.textContent = 'One or several of substrings is not a number';
            return;
        }

        numbers.push(mayNumber);
    }

    numbers.sort((x, y) => { return x - y; });

    min10nums = numbers.slice(0, 10);

    status.textContent = ! (min10nums.length >= 10) ? 'Warning: less than 10 numbers' : "It's ok!";

    alert('Top 10 min numbers: ' + numbers.join(' '));

    cookie_set(TASK_3_COOKIE_NAME, numbers.join(' '));
}

function task_3_startup()
{
    let min10numsCookie = cookie_get(TASK_3_COOKIE_NAME);

    if (min10numsCookie == null)
    {
        return;
    }

    let result = window.confirm('Hello, my homies! Top 10 min numbers: ' + min10numsCookie + '. Do you want to clean?');

    if (! result)
    {
        alert('So, there is a cookie! Please, reload a web-page!');

        return;
    }

    cookie_remove(TASK_3_COOKIE_NAME);

    document.getElementById('task-3-output-status').textContent = 'Cleaned!';
}

/* Task 4 */

const TASK_4_LOCAL_STORAGE = 'task_4';

function task_4_set_bg(rgb)
{
    let style = document.querySelector('.l-side-1');

    style.style.backgroundColor = rgb;
}

function task_4_event()
{
    let rgb = document.getElementById('task-4-input').value;

    task_4_set_bg(rgb);

    store_set(TASK_4_LOCAL_STORAGE, rgb);
}

function task_4_startup()
{
    let mayRgb = store_get(TASK_4_LOCAL_STORAGE);

    if (mayRgb == null)
    {
        return;
    }

    task_4_set_bg(mayRgb);
}

/* Task 5 */

const TASK_5_BLOCK_NAMES =
[
    'header',
    'r-side',
    'l-side-1',
    'l-side-2',
    'main',
    'footer'
];

const original_blocks_content = {};
const original_blocks_background = {};

function task_5_local_storage(clazz)
{
    return `task_5_content_${clazz}`;
}

function task_5_background(clazz)
{
    return `task_5_bg_${clazz}`;
}

function task_5_editor(clazz)
{
    return `task-5-editor-${clazz}`
}

function task_5_edit(clazz)
{
    let block = document.getElementsByClassName(clazz)[0];

    let html = '<no html!>';

    let html_from_store = store_get(task_5_local_storage(clazz));

    if (html_from_store != null)
    {
        html = html_from_store;
    }
    else
    {
        html = original_blocks_content[clazz];
    }

    let editor = `
        <div style='width: auto; height: auto;'>
            <p>HTML editor is here:</p>

            <textarea id='${task_5_editor(clazz)}' rows='8' cols='40'>${html}</textarea>

            <br/>

            <button onclick='task_5_change("${clazz}")'>Change!</button>
        </div>
    `;

    block.setHTMLUnsafe(editor);
}

function task_5_change(clazz)
{
    let editor = document.getElementById(task_5_editor(clazz));

    let new_html = editor.value + `<button onclick='task_5_reset("${clazz}")'>Reset!</button>`;

    store_set(task_5_local_storage(clazz), new_html);

    document.getElementsByClassName(clazz)[0].setHTMLUnsafe(new_html);

    let randomNumber = Math.floor(Math.random() * 16777215);

    let blockStyle = document.querySelector(`.${clazz}`);

    let rgb = `#${randomNumber.toString(16).padStart(6, '0')}`;

    blockStyle.style.backgroundColor = rgb;

    store_set(task_5_background(clazz), rgb);
}

function task_5_reset(clazz)
{
    store_remove(task_5_local_storage(clazz));
    store_remove(task_5_background(clazz));

    let original_html = original_blocks_content[clazz];

    document.getElementsByClassName(clazz)[0].setHTMLUnsafe(original_html);

    document.querySelector(`.${clazz}`).style.backgroundColor
        = original_blocks_background[clazz];
}

function task_5_startup()
{
    for (
        let clazz
        of TASK_5_BLOCK_NAMES
    )
    {
        // get original HTML content

        let block = document.getElementsByClassName(clazz)[0];

        original_blocks_content[clazz] = block
            .getHTML();
        
        original_blocks_background[clazz] =
            document.querySelector(`.${clazz}`).style.backgroundColor;

        // populate root blocks with on double click editors

        block.setAttribute('ondblclick', `task_5_edit("${clazz}")`);

        // override if it is changed
        
        let override_html = store_get(task_5_local_storage(clazz));

        if (override_html == null)
        {
            continue;
        }

        document.querySelector(`.${clazz}`).style.backgroundColor = store_get(task_5_background(clazz));
        block.setHTMLUnsafe(override_html);
    }
}

/* Initialization */

task_3_startup();
task_4_startup();
task_5_startup();
