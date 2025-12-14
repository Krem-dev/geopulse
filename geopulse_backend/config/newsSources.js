const newsSources = {
  Ghana: [
    {
      name: 'GhanaWeb',
      url: 'https://www.ghanaweb.com',
      selector: 'h3 a, h2 a, .headline a',
      type: 'scrape',
    },
    {
      name: 'MyJoyOnline',
      url: 'https://www.myjoyonline.com',
      selector: 'h3 a, h2 a, .entry-title a',
      type: 'scrape',
    },
    {
      name: 'Citinewsroom',
      url: 'https://citinewsroom.com',
      selector: 'h2 a, h3 a, .entry-title a',
      type: 'scrape',
    },
    {
      name: 'Graphic Online',
      url: 'https://www.graphic.com.gh',
      selector: 'h3 a, h2 a, .title a',
      type: 'scrape',
    },
  ],
  Nigeria: [
    {
      name: 'Punch',
      url: 'https://punchng.com',
      selector: 'h3 a',
      type: 'scrape',
    },
    {
      name: 'Vanguard',
      url: 'https://www.vanguardngr.com',
      selector: '.entry-title a',
      type: 'scrape',
    },
    {
      name: 'Premium Times',
      url: 'https://www.premiumtimesng.com',
      selector: '.entry-title a',
      type: 'scrape',
    },
  ],
  USA: [
    {
      name: 'CNN',
      url: 'https://www.cnn.com',
      selector: 'span.container__headline-text',
      type: 'scrape',
    },
    {
      name: 'NBC News',
      url: 'https://www.nbcnews.com',
      selector: 'h2.tease-card__headline a',
      type: 'scrape',
    },
  ],
  UK: [
    {
      name: 'BBC News',
      url: 'https://www.bbc.com/news',
      selector: 'a[data-testid="internal-link"]',
      type: 'scrape',
    },
    {
      name: 'The Guardian',
      url: 'https://www.theguardian.com',
      selector: 'a.u-faux-block-link__overlay',
      type: 'scrape',
    },
  ],
  Canada: [
    {
      name: 'CBC News',
      url: 'https://www.cbc.ca/news',
      selector: '.card h3 a',
      type: 'scrape',
    },
    {
      name: 'CTV News',
      url: 'https://www.ctvnews.ca',
      selector: '.c-list__item h3 a',
      type: 'scrape',
    },
  ],
  Kenya: [
    {
      name: 'Daily Nation',
      url: 'https://nation.africa/kenya',
      selector: '.article-title a',
      type: 'scrape',
    },
    {
      name: 'The Standard',
      url: 'https://www.standardmedia.co.ke',
      selector: '.article-title a',
      type: 'scrape',
    },
  ],
  'South Africa': [
    {
      name: 'News24',
      url: 'https://www.news24.com',
      selector: '.article-title a',
      type: 'scrape',
    },
    {
      name: 'IOL',
      url: 'https://www.iol.co.za',
      selector: '.article-title a',
      type: 'scrape',
    },
  ],
};

module.exports = newsSources;
