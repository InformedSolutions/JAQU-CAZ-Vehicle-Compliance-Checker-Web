import './styles.scss'

const cookieKey = 'seen_cookie_message';
const dayInMS = (1000 * 60 * 60 * 24);
const yearInMS = dayInMS * 365 ;
const hideClass = 'global-cookie-message__hidden';

function init() {
    if(!hasSeenMessage()){
        const banner = document.getElementById('global-cookie-message');
        banner.classList.remove(hideClass);
        const closeLink = banner.querySelector('#close-banner');
        closeLink.addEventListener('click', () => {
            banner.classList.add(hideClass);
            setCookie()
        })
    }
}

function hasSeenMessage(){
    return document.cookie.indexOf(cookieKey + '=true') > -1
}

function setCookie(){
    const date = new Date();
    date.setTime(date.getTime() + yearInMS);
    // we set cookies `seen_cookie_message` because it non-sensitive information that need to live
    // longer than the user session.
    // https://rules.sonarsource.com/csharp/tag/owasp/RSPEC-2255
    document.cookie = cookieKey + '=true; expires=' + date.toGMTString();
}

export default init;
