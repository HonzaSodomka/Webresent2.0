import type { APIRoute } from 'astro';
import nodemailer from 'nodemailer';

export const POST: APIRoute = async ({ request }) => {
  try {
    const data = await request.json();
    const { name, phone, email, project_type, existing_url, message } = data;

    // Údaje se načítají bezpečně z .env souboru
    const transporter = nodemailer.createTransport({
      host: import.meta.env.SMTP_HOST,
      port: Number(import.meta.env.SMTP_PORT),
      secure: false, // Důležité: pro port 587 to musí být false
      auth: {
        user: import.meta.env.SMTP_USER,
        pass: import.meta.env.SMTP_PASS,
      },
    });

    // Sestavení a odeslání e-mailu
    await transporter.sendMail({
      from: '"Webresent Poptávka" <webresentcz@gmail.com>',
      to: "info@webresent.cz",
      replyTo: email,
      subject: `Nová poptávka z webu: ${project_type} od ${name}`,
      html: `
        <h2 style="color: #2563eb;">Nová poptávka z webu Webresent</h2>
        <p><strong>Jméno a příjmení:</strong> ${name}</p>
        <p><strong>E-mail:</strong> ${email}</p>
        <p><strong>Telefon:</strong> ${phone || 'Nezadán'}</p>
        <p><strong>Typ webu:</strong> ${project_type}</p>
        <p><strong>Stávající web:</strong> ${existing_url || 'Nezadán'}</p>
        <hr />
        <h3>Zpráva / Popis projektu:</h3>
        <p style="white-space: pre-wrap;">${message}</p>
      `,
    });

    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });

  } catch (error) {
    console.error("Chyba při odesílání emailu:", error);
    return new Response(JSON.stringify({ error: "Chyba při odesílání emailu" }), { status: 500 });
  }
};
