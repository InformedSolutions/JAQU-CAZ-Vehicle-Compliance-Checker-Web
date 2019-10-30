import './styles.scss'

const cookieKey = 'seen_cookie_message';
const monthInMS = 2629746000;
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
    date.setTime(date.getTime() + monthInMS);
    document.cookie = cookieKey + '=true; expires=' + date.toGMTString();
}

export default init;
