            </main>

        <footer>
            <div class="footer-wrapper wrapper center">
                {hook h='displayFooter' mod='tbhtmlblock'}
                {hook h='displayFooter' mod='blocksocial'}

                <div class="copyright spooky-font" role="contentinfo" >
                    Copyright © {date("Y")|intval}
                </div>
            </div>
        </footer>
        {include file="$tpl_dir./global.tpl"}
    </body>
</html>