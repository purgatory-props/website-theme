{hook h='actionModifyProductForExtraFunctionality' product=$product}
{if (!isset($product->coming_soon) || !$product->coming_soon) && (!isset($product->hide_comments) || !$product->hide_comments) && (!isset($product->is_service) || !$product->is_service)}

{assign var=tabID value="tab-reviews"}
<input name="product-tabs" type="radio" id="{$tabID}" class="tab-switch" autocomplete="off"/>
<label for="{$tabID}" class="tab-label noselect">{l s='Reviews'}</label>

<div id="reviews-tab" class="product-tab reviews-tab">
    {if (!$too_early && ($is_logged || $allow_guests))}
        {if !isset($product->discontinued) || !$product->discontinued}
            {* Review Form *}
            <div id="new_comment_form" style="display: none">
                <form id="id_new_comment_form" action="#">
                    <h2 class="page-subheading">{l s='Write Your Review' mod='productcomments'}</h2>

                    <div id="new_comment_form_error" class="alert alert-danger" style="display: none;">
                        <ul></ul>
                    </div>

                    {if !empty($criterions)}
                        {foreach from=$criterions item='criterion'}
                            <div class="form-group clearfix">
                                <label>{l s='Rating'}</label>
                                <div class="form-control-static">
                                    <div class="star_content">
                                        <input class="star" type="radio" name="criterion[{$criterion.id_product_comment_criterion|round}]" value="1">
                                        <input class="star" type="radio" name="criterion[{$criterion.id_product_comment_criterion|round}]" value="2">
                                        <input class="star" type="radio" name="criterion[{$criterion.id_product_comment_criterion|round}]" value="3">
                                        <input class="star" type="radio" name="criterion[{$criterion.id_product_comment_criterion|round}]" value="4">
                                        <input class="star" type="radio" name="criterion[{$criterion.id_product_comment_criterion|round}]" value="5" checked="checked">
                                    </div>
                                </div>
                            </div>
                        {/foreach}
                    {/if}

                    {if $allow_guests == true && !$is_logged}
                        <div class="form-group">
                            <label for="commentCustomerName">
                                {l s='Your Name' mod='productcomments'} <sup class="required">*</sup>
                            </label>
                            <input id="commentCustomerName" class="form-control" name="customer_name" type="text" value="" autocomplete="name" required>
                        </div>
                    {/if}

                    <div class="form-group">
                        <label for="comment_title">{l s='Title' mod='productcomments'} <sup class="required">*</sup></label>
                        <input id="comment_title" class="form-control" name="title" type="text" value="" autocomplete="off" required>
                    </div>

                    <div class="form-group">
                        <label for="content">{l s='Review' mod='productcomments'} <sup class="required">*</sup></label>
                        <textarea id="content" class="form-control" name="content" autocomplete="off" required></textarea>
                    </div>

                    <div id="new_comment_form_footer" class="clearfix">
                        <input id="id_product_comment_send" name="id_product" type="hidden" value='{$id_product_comment_form}'>
                        <p class="help-block">
                            <sup class="required">*</sup> {l s='Required Field' mod='productcomments'}
                        </p>
                        <button id="submitNewMessage" name="submitMessage" type="submit" class="btn btn-success">
                            {l s='Submit' mod='productcomments'}
                        </button>
                        <a class="closefb btn btn-link" href="#" id="close_comment_form">
                            {l s='Cancel' mod='productcomments'}
                        </a>
                    </div>
                </form>
            </div>

            {* Write a Review Button *}
            <a id="new_comment_tab_btn" class="btn btn-success open-comment-form" href="#" style="margin-left: 0px">
                {l s='Write a Review'}
            </a>
        {/if}
    {/if}
    {if !$is_logged}
        <div>
            <a class="textlink" href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}">{l s='Sign-In or Create an Account to Write a Review'}</a>
        </div>
    {/if}

    {* List of Reviews *}
    {if !empty($comments)}
        {foreach from=$comments item=review}
            {if !empty($review.content) && !$review.custom}
                <div class="product-review" itemprop="review" itemscope itemtype="https://schema.org/Review">
                    <meta itemprop="datePublished" content="{$review.date_add|escape:'html':'UTF-8'|substr:0:10}">
                    <meta itemprop="worstRating" content = "0">
                    <meta itemprop="ratingValue" content = "{$review.grade|escape:'html':'UTF-8'}">
                    <meta itemprop="bestRating" content = "5">

                    <div class="review-rating clearfix" itemprop="reviewRating" itemscope itemtype="https://schema.org/Rating">
                         {section name="i" start=0 loop=5 step=1}
                            {if $review.grade <= $smarty.section.i.index}
                                <div class="star"></div>
                            {else}
                                <div class="star star_on"></div>
                            {/if}
                        {/section}
                    </div>

                    <div class="review-title" itemprop="name">{$review.title}</div>

                    <div class="review-author small noselect">
                        <span itemprop="author">{$review.customer_name|escape:'html':'UTF-8'}</span>
                        on
                        <span>{dateFormat date=$review.date_add|escape:'html':'UTF-8' full=0}</span>
                    </div>

                    <div class="review-body" itemprop="reviewBody">{$review.content|escape:'html':'UTF-8'|nl2br}</div>

                    <div class="review-feedback">
                        {if $is_logged}
                            {if !$review.customer_report}
                                <div class="report-review">
                                    <a href="#" id="review-report" class="report_btn textlink textlink-nostyle" data-id-product-comment="{$review.id_product_comment}">
                                        {l s='Report Review'}
                                    </a>
                                </div>
                            {/if}
                        {/if}
                    </div>
                </div>
            {/if}
        {/foreach}
    {else}
        <br/>{l s='There are no reviews yet.'}
    {/if}
</div>


{strip}
  {addJsDef productcomments_controller_url=$productcomments_controller_url|@addcslashes:'\''}
  {addJsDef moderation_active=$moderation_active|boolval}
  {addJsDef productcomments_url_rewrite=$productcomments_url_rewriting_activated|boolval}
  {addJsDef secure_key=$secure_key}

  {addJsDefL name=confirm_report_message}{l s='Are you sure that you want to report this review?' mod='productcomments' js=1}{/addJsDefL}
  {addJsDefL name=productcomment_added}{l s='Your review has been added!' mod='productcomments' js=1}{/addJsDefL}
  {addJsDefL name=productcomment_added_moderation}{l s='Your review has been added and will be available once approved by a moderator.' mod='productcomments' js=1}{/addJsDefL}
  {addJsDefL name=productcomment_title}{l s='New Review' mod='productcomments' js=1}{/addJsDefL}
  {addJsDefL name=productcomment_ok}{l s='Ok' mod='productcomments' js=1}{/addJsDefL}
{/strip}
{/if}