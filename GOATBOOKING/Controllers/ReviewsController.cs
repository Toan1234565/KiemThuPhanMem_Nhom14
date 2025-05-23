using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GOATBOOKING.Models;

namespace GOATBOOKING.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReviewsController : ControllerBase
    {
        private readonly MasterContext _context;

        public ReviewsController(MasterContext context)
        {
            _context = context;
        }

        // GET: api/Reviews
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Review>>> GetReviews()
        {
            return await _context.Reviews.ToListAsync();
        }

        

        // lấy review theo homestay
        [HttpGet("Review_Homestay")]
        public async Task<ActionResult<IEnumerable<Review>>> GetReview_Homestay([FromQuery] int id)
        {
            var query = _context.Reviews.AsQueryable();
            query = query.Where(r => r.HomestayId == id);

            var reviews = await query.ToListAsync();

            if( reviews == null || reviews.Count == 0)
            {
                return NotFound("Không có");
            }
            else
            {
                return Ok(reviews);
            }
        }
        // GET: api/Reviews/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Review>> GetReview(long id)
        {
            var review = await _context.Reviews.FindAsync(id);

            if (review == null)
            {
                return NotFound();
            }

            return review;
        }

        [HttpGet("search")]

        public async Task<ActionResult<IEnumerable<Review>>> GetReviews([FromQuery] string search)
        {                                                                   // FromQuery được lấy từ Urk 
            var query = _context.Reviews.AsQueryable();
            // lấy cơ sở dữ liệu ra

            if (!string.IsNullOrWhiteSpace(search))
            {
                query = query.Where(h => h.ReviewId.ToString().Contains(search) ||
                                         h.Rate.ToString().Contains(search) ||
                                         h.Comment.ToString().Contains(search) ||
                                        h.HomestayId.ToString().Contains(search) ||
                                        h.UserId.ToString().Contains(search)||
                                         h.CreatedAt.ToString().Contains(search) ||
                                         h.UpdatedAt.ToString().Contains(search));
            }
            var Reviews = await query.ToListAsync();

            if (Reviews == null || Reviews.Count == 0)
            {
                return NotFound();
            }
            else
            {
                return Ok(Reviews);
            }
        }
        // PUT: api/Reviews/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutReview(long id, Review review)
        {
            if (id != review.ReviewId)
            {
                return BadRequest();
            }

            _context.Entry(review).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ReviewExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Reviews
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Review>> PostReview(Review review)
        {
            if (_context.Reviews.Any(u => u.ReviewId == review.ReviewId))
            {
                return Conflict("UserId đã tồn tại.");
            }

            // Đảm bảo các thuộc tính khác đã được gán đúng
            // cũ
            review.CreatedAt = GetFormattedDateAsLong();
            review.UpdatedAt = review.CreatedAt;

            // Thêm vào cơ sở dữ liệu
            _context.Reviews.Add(review);

            try
            {
                await _context.SaveChangesAsync();  // Lưu vào DB
            }
            catch (DbUpdateException)
            {
                // Nếu có lỗi trong quá trình lưu, trả lại lỗi
                return StatusCode(500, "Lỗi khi lưu dữ liệu.");
            }


            return CreatedAtAction("GetReview", new { id = review.ReviewId }, review);
        }
        private long GetFormattedDateAsLong()
        {
            var now = DateTime.Now;
            var formattedDate = now.ToString("yyyyMMdd"); // Chuyển thành chuỗi "YYYYMMDD"
            return long.Parse(formattedDate);  // Chuyển chuỗi thành long
        }

        // DELETE: api/Reviews/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteReview(long id)
        {
            var review = await _context.Reviews.FindAsync(id);
            if (review == null)
            {
                return NotFound();
            }

            _context.Reviews.Remove(review);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ReviewExists(long id)
        {
            return _context.Reviews.Any(e => e.ReviewId == id);
        }
    }
}
