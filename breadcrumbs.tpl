{assign var='forbiddenPages' value=['index', 'pagenotfound', 'sitemap', 'authentication', 'order']}

{if !in_array($page_name, $forbiddenPages) && (!isset($no_breadcrumbs) || !$no_breadcrumbs)}

{if isset($smarty.capture.path)}{assign var='path' value=$smarty.capture.path}{/if}

{if !empty($path)}
  {* Extract bradcrumb links from anchors *}
  {assign var='matches' value=[]}
  {$matchCount = preg_match_all('/<a.+?href="(.+?)"[^>]*>([^<]*)<\/a>/', $path, $matches)}
  {$breadcrumbs = []}
  {for $i=0; $i<$matchCount; $i++}
    {$breadcrumbs[] = ['url' => $matches[1][$i], 'title' => $matches[2][$i]]}
  {/for}

  {* Extract the last breadcrumb which is not link, it's plain text or text inside span *}
  {$match = preg_match('/>([^<]+)(?:<\/\w+>\s*)?$/', $path, $matches)}
  {if !empty($matches[1])}
    {$breadcrumbs[] = ['url' => '', 'title' => $matches[1]]}
  {elseif !$match && !$matchCount}
    {$breadcrumbs[] = ['url' => '', 'title' => $path]}
  {/if}
{/if}


<div class="breadcrumbs-container clearfix no-print">
    <div class="wrapper slightly-smaller center">
        <ol class="breadcrumb list-unstyled no-mobile" itemscope itemtype="http://schema.org/BreadcrumbList">
          <li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
            <a href="{if isset($force_ssl) && $force_ssl}{$base_dir_ssl}{else}{$base_dir}{/if}" title="{l s='Home Page'}" itemprop="item">
              <span itemprop="name">{l s='Home'}</span>
            </a>
            <meta itemprop="position" content="1">
          </li>

          {if !empty($breadcrumbs)}
            {foreach from=$breadcrumbs item=breadcrumb name=crumbs key=index}
              <li class="desktop-crumb" itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
                {if !empty($breadcrumb.url)}
                  <a href="{$breadcrumb.url}" itemprop="item">
                    <span itemprop="name">{$breadcrumb.title}</span>
                  </a>
                {else}
                  <a href="#" title="{$breadcrumb.title}" itemprop="item" class="current">
                    <span itemprop="name">{$breadcrumb.title}</span>
                  </a>
                {/if}
                <meta itemprop="position" content="{($smarty.foreach.crumbs.iteration|intval + 1)}">

                {if $index == (count($breadcrumbs) - 2)}
                  {assign var='parentCrumb' value=$breadcrumb}
                {/if}
              </li>
            {/foreach}
          {/if}
        </ol>

        <ol class="breadcrumb list-unstyled no-desktop" itemscope itemtype="http://schema.org/BreadcrumbList">
          {if !isset($parentCrumb) || count($breadcrumbs) == 0}
            {assign var=parentCrumb value=[ 'url' => (isset($force_ssl) && $force_ssl) ? $base_dir_ssl : $base_dir, 'title' => 'Home']}
          {/if}

          {if isset($parentCrumb)}
            <li class="mobile-crumb" itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
              <a href="{$parentCrumb.url}" title="{l s='Back to'} {$parentCrumb.title}">&lt; {l s='Back to'} {$parentCrumb.title}</a>
            </li>
          {/if}
        </ol>
    </div>
</div>

{if isset($smarty.get.search_query) && isset($smarty.get.results) && $smarty.get.results > 1 && isset($smarty.server.HTTP_REFERER)}
  <nav class="wrapper slightly-smaller center">
    <ul class="pager">
      <li class="previous">
        {capture}{if isset($smarty.get.HTTP_REFERER) && $smarty.get.HTTP_REFERER}{$smarty.get.HTTP_REFERER}{elseif isset($smarty.server.HTTP_REFERER) && $smarty.server.HTTP_REFERER}{$smarty.server.HTTP_REFERER}{/if}{/capture}
        <a class="textlink-nostyle" href="{$smarty.capture.default|escape:'html':'UTF-8'|secureReferrer|regex_replace:'/[\?|&]content_only=1/':''}" name="back">
          <span>
            {if $isRtl}&rarr;{else}&larr;{/if} {l s='Back to Search results for "%s" (%d other results)' sprintf=[$smarty.get.search_query,$smarty.get.results]}
          </span>
        </a>
      </li>
    </ul>
  </nav>
{/if}
{/if} {* Forbidden Pages Check *}