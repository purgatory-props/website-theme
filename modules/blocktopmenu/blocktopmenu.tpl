{if $MENU != ''}
    <nav id="menu">
        <!-- Desktop Menu -->
        <div class="header-wrapper wrapper no-mobile">
            <ul id="desktop-menu" class="clearfix menu-content">
                {$MENU}
            </ul>
        </div>

        <!-- Mobile Menu -->
        <div class="header-wrapper wrapper no-desktop mobile-menu-btn" id="mobile-menu-button" onclick="showMobileMenu()">
            <div class="mobile-menu-btn-wrapper">
                <div class="left" id="hide-when-menu-is-shown">{l s='MENU' mod='blocktopmenu'}</div>
                <div class="right">
                    <i class="fa fa-bars open-btn"></i>
                    <i class="fa fa-times close-btn"></i>
                </div>
            </div>
        </div>

        <div class="header-wrapper wrapper mobile-menu" id="mobile-menu">
             <ul class="clearfix mobile-menu-content">
                {$MENU}

                <li class="no-hover"><hr/></li>
                <li>
                    <a href="{$link->getPageLink('search', true)|escape:'html':'UTF-8'}">
                        {l s='Search'}
                    </a>
                </li>
                <li>
                    <a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">
                        {if $is_logged}{l s='Your Account'}{else}{l s='Login/Signup'}{/if}
                    </a>
                </li>
                <li>
                    <a href="{$link->getPageLink('order', true)|escape:'html':'UTF-8'}">
                        {l s='Cart'} ({$cart_qties} {if $cart_qties == 1}{l s='item'}{else}{l s='items'}{/if})
                    </a>
                </li>
            </ul>
        </div>

        <script type="text/javascript">
            function showMobileMenu() {
                var menu = document.getElementById('menu');
                var x = document.getElementById("mobile-menu");
                var menuBtn = document.getElementById('hide-when-menu-is-shown');
                if (x.style.display === "block") {
                    x.style.display = "none";
                    menu.classList.remove('expand');
                    menuBtn.style['visibility'] = 'visible';
                } else {
                    x.style.display = "block";
                    menu.classList.add('expand');
                    menuBtn.style['visibility'] = 'hidden';
                }
            }

            var allMenuLinks = document.querySelectorAll('#desktop-menu li');
            for (var i = 0; i < allMenuLinks.length; i++) {
                var submenus = allMenuLinks[i].getElementsByTagName('ul');
                if (submenus.length == 1) {
                    var menuLink = allMenuLinks[i].getElementsByTagName('a')[0];
                    var submenu = submenus[0];

                    var newMenuItem = document.createElement('li');
                    var newMenuItemLink = document.createElement('a');
                    newMenuItemLink.setAttribute('href', menuLink.getAttribute('href'));
                    newMenuItemLink.setAttribute('title', menuLink.getAttribute('title'));
                    newMenuItemLink.innerHTML = '{l s='All'} ' + menuLink.innerHTML;
                    newMenuItem.appendChild(newMenuItemLink);

                    submenu.insertBefore(newMenuItem, submenu.childNodes[0]);
                }
            }
        </script>
    </nav>
{/if}
